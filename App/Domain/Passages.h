#import <Foundation/Foundation.h>
#import "CachedPassage.h"

@protocol PassageDelegate;

@interface Passages : NSObject

- (CachedPassage *)passageForReference:(NSString *)reference delegate:(id<PassageDelegate>)delegate;
- (void)forgetDelegate:(id<PassageDelegate>)delegate;

@end

@protocol PassageDelegate

- (void)didDownloadPassageForReference:(NSString *)reference;

@end