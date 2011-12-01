#import "ReaderTabBarController.h"
#import "NSDate+FPCBReader.h"
#import "ReadingViewController.h"
#import "TodaysReadingDataSource.h"
#import "NextUnreadReadingDataSource.h"

@implementation ReaderTabBarController

- (id)init {
    self = [super init];
    if (self) {           
        self.viewControllers = [NSArray arrayWithObjects:
                                [ReadingViewController controllerWithDataSource:[TodaysReadingDataSource dataSource]],
                                [ReadingViewController controllerWithDataSource:[NextUnreadReadingDataSource dataSource]],
                                nil];
    }
    return self;
}

@end
