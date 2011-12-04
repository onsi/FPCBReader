#import "SpecificReadingDataSource.h"
#import "Reading.h"

@interface SpecificReadingDataSource ()

@property (nonatomic, assign) Reading *reading;

@end

@implementation SpecificReadingDataSource

@synthesize reading = reading_;

+ (SpecificReadingDataSource *)dataSourceWithReading:(Reading *)reading {
    SpecificReadingDataSource *dataSource = [[[self alloc] init] autorelease];
    dataSource.reading = reading;
    return dataSource;
}

@end
