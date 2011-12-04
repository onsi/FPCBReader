#import "NextUnreadReadingDataSource.h"
#import "Reading.h"

@implementation NextUnreadReadingDataSource

+ (NextUnreadReadingDataSource *)dataSource {
    return [[[self alloc] init] autorelease];
}

- (Reading *)reading {
    return [Reading nextUnreadReading];
}

@end
