#import <Foundation/Foundation.h>
#import "ReadingDataSource.h"

@interface NextUnreadReadingDataSource : NSObject <ReadingDataSource>

+ (NextUnreadReadingDataSource *)dataSource;

@end
