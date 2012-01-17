#import <Foundation/Foundation.h>
#import "Passage.h"

@interface UncachedPassage : NSObject <Passage>

@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *reference;

+ (id<Passage>)passageForReference:(NSString *)reference;

@end
