#import <Cedar-iPhone/SpecHelper.h>
using namespace Cedar::Matchers;

#import "CachedPassage+Spec.h"
#import "Reader.h"


@interface CachedPassage (privateSpec)

+ (CachedPassage *)_passageForReference:(NSString *)reference;
- (void)save;

@end

@implementation CachedPassage (Spec)

+ (CachedPassage *)passageWithReference:(NSString *)reference
                                content:(NSString *)content
                                   date:(NSDate *)date {
    
    [self _passageForReference:reference] should be_nil();
    CachedPassage *passage = [NSEntityDescription insertNewObjectForEntityForName:@"CachedPassage"
                                                           inManagedObjectContext:reader.dataManager.managedObjectContext];
    
    passage.reference = reference;
    passage.content = content;
    passage.date = date;
    [passage save];
    return passage;
}

@end
