#import <Foundation/Foundation.h>
#import "ReadingDataSource.h"

@class Reading;

@interface SpecificReadingDataSource : NSObject <ReadingDataSource>

+ (SpecificReadingDataSource *)dataSourceWithReading:(Reading *)reading;

@end
