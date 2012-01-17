#import "CachedPassage.h"
#import "Reader.h"

@interface CachedPassage ()

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *downloadData;

+ (CachedPassage *)_passageForReference:(NSString *)reference;
+ (void)ensureCacheLimit;
- (void)save;
- (NSURL *)url;
- (void)download;
- (void)cancelDownload;

@end

@implementation CachedPassage

@dynamic date;
@dynamic content;
@dynamic reference;
@synthesize
    connection = connection_,
    downloadData = downloadData_;


+ (CachedPassage *)passageForReference:(NSString *)reference {
    CachedPassage *passage = [self _passageForReference:reference];
    if (passage) {
        passage.date = [NSDate date];
    } else {
        [self ensureCacheLimit];
        passage = [NSEntityDescription insertNewObjectForEntityForName:@"CachedPassage"
                                                inManagedObjectContext:reader.dataManager.managedObjectContext];
        passage.reference = reference;
        passage.content = nil;
        passage.date = [NSDate date];
    }
    
    if (!passage.content) {
        [passage download];
    }
    
    [passage save];
    return passage;
}

+ (CachedPassage *)_passageForReference:(NSString *)reference {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CachedPassage"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"reference = %@", reference]];
    NSArray *results = [reader.dataManager.managedObjectContext executeFetchRequest:request error:NULL];

    return results.lastObject;
}

+ (void)ensureCacheLimit {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CachedPassage"];
    NSUInteger count = [reader.dataManager.managedObjectContext countForFetchRequest:request error:NULL];
    if (count < 30) {
        return;
    }
    
    [request setFetchLimit:1];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    NSArray *results = [reader.dataManager.managedObjectContext executeFetchRequest:request error:NULL];

    [reader.dataManager.managedObjectContext deleteObject:results.lastObject];
    [reader.dataManager.managedObjectContext save:NULL];
}

- (void)save {
    [reader.dataManager saveContext];
}

- (void)didTurnIntoFault {
    [self cancelDownload];
    [super didTurnIntoFault];
}

- (void)prepareForDeletion {
    [self cancelDownload];
    [super prepareForDeletion];
}

#pragma mark Downloading
- (void)cancelDownload {
    [self.connection cancel];
    self.connection = nil;
    self.downloadData = nil;
}

- (NSURL *)url {
    NSString *baseURL = @"http://www.esvapi.org/v2/rest/passageQuery?key=IP&include-footnotes=false&include-audio-link=false";
    NSString *urlString = [[NSString stringWithFormat:@"%@&passage=%@", baseURL, self.reference] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:urlString];
}

- (void)download {
    if (self.connection) {
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (self.connection) {
        self.downloadData = [NSMutableData data];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.downloadData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.connection = nil;
    self.downloadData = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadDidFail" object:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.content = [[[NSString alloc] initWithData:self.downloadData encoding:NSUTF8StringEncoding] autorelease];
    self.date = [NSDate date];
    [self save];
    
    self.connection = nil;
    self.downloadData = nil;    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didDownloadPassage" object:self];
}

@end