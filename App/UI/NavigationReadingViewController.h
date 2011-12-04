#import "ReadingViewController.h"

@interface NavigationReadingViewController : ReadingViewController

+ (NavigationReadingViewController *)navigationControllerWithDataSource:(id<ReadingDataSource>)dataSource;

@end
