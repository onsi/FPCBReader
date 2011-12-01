#import <Foundation/Foundation.h>
#import "ReadingDataSource.h"

@interface TodaysReadingDataSource : NSObject <ReadingDataSource>

+ (TodaysReadingDataSource *)dataSource;

@end
