#import "UncachedPassage.h"
#import "Reader.h"

UncachedPassage *thePassage;

@interface UncachedPassage ()

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *downloadData;

- (NSURL *)url;
- (void)download;
- (void)cancelDownload;

@end

@implementation UncachedPassage

@synthesize
    content = content_,
    reference = reference_,
    connection = connection_,
    downloadData = downloadData_;


+ (void)resetCache {
    thePassage = nil;
}

+ (id<Passage>)passageForReference:(NSString *)reference {
    if (![thePassage.reference isEqualToString:reference]) {
        [thePassage release];
        thePassage = [[UncachedPassage alloc] init];
        thePassage.reference = reference;
        thePassage.content = nil;
    }
    
    if (!thePassage.content) {
        [thePassage download];
    }

    return thePassage;
}

- (void)dealloc {
    [self cancelDownload];
    self.content = nil;
    self.reference = nil;
    self.connection = nil;
    self.downloadData = nil;
    [super dealloc];
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
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
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
    
    self.connection = nil;
    self.downloadData = nil;    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didDownloadPassage" object:self];
}

@end