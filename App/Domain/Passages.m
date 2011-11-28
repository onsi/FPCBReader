#import "Passages.h"

@interface Passages ()

@end

@implementation Passages

- (CachedPassage *)passageForReference:(NSString *)reference delegate:(id<PassageDelegate>)delegate {
    return nil;
}

- (void)forgetDelegate:(id<PassageDelegate>)delegate {
}

@end