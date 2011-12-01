#import "TodaysReadingDataSource.h"
#import "Reading.h"

@implementation TodaysReadingDataSource

+ (TodaysReadingDataSource *)dataSource {
    return [[[self alloc] init] autorelease];
}

- (Reading *)reading {
    return [Reading todaysReading];
}

- (NSString *)tabItemTitle {
    return @"Today";
}

@end
