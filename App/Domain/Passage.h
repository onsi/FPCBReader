#import <Foundation/Foundation.h>

@protocol Passage <NSObject>

@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *reference;

+ (id<Passage>)passageForReference:(NSString *)reference;
- (NSURL *)url;

@end