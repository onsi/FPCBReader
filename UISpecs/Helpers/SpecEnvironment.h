#import <Foundation/Foundation.h>
#import "Reader.h"
#import "NSDate+FPCBReader.h"

@interface SpecEnvironment : NSObject

+ (void)setUpReadingPlist;

+ (NSDate *)today;
+ (NSDate *)tomorrow;
+ (NSDate *)yesterday;

@end
