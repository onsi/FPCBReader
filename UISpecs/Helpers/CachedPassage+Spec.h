#import "CachedPassage.h"

@interface CachedPassage (Spec)

+ (CachedPassage *)passageWithReference:(NSString *)reference
                                content:(NSString *)content
                                   date:(NSDate *)date;

@end

@interface CachedPassage (SpecPublicMethods)

- (NSURL *)url;

@end