#import <Foundation/Foundation.h>

@interface NSDate (FPCBReader)

- (NSDate *)dateByRemovingTimeComponent;
- (NSString *)readerFormat;

@end
