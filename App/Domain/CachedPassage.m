#import "CachedPassage.h"
#import "Reader.h"

@interface CachedPassage ()

+ (CachedPassage *)_passageForReference:(NSString *)reference;

@end

@implementation CachedPassage

@dynamic date;
@dynamic content;
@dynamic reference;

+ (CachedPassage *)_passageForReference:(NSString *)reference {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CachedPassage"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"reference = %@", reference]];
    NSArray *results = [reader.dataManager.managedObjectContext executeFetchRequest:request error:NULL];

    return results.lastObject;
}

+ (CachedPassage *)passageWithReference:(NSString *)reference
                                content:(NSString *)content {

    CachedPassage *passage = [self _passageForReference:reference];
    if (!passage) {
        passage = [NSEntityDescription insertNewObjectForEntityForName:@"CachedPassage"
                                                inManagedObjectContext:reader.dataManager.managedObjectContext];
    }
    
    passage.reference = reference;
    passage.content = content;
    passage.date = [NSDate date];
    [passage save];
    return passage;
}

+ (CachedPassage *)passageForReference:(NSString *)reference {
    CachedPassage *passage = [self _passageForReference:reference];
    passage.date = [NSDate date];
    [passage save];
    return passage;
}

+ (CachedPassage *)oldestPassage {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CachedPassage"];
    [request setFetchLimit:1];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    NSArray *results = [reader.dataManager.managedObjectContext executeFetchRequest:request error:NULL];
    return results.lastObject;
}

- (void)save {
    [reader.dataManager saveContext];
}

@end