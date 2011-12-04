#import "ReaderTabBarController.h"
#import "NSDate+FPCBReader.h"
#import "ReadingViewController.h"
#import "TodaysReadingDataSource.h"
#import "NextUnreadReadingDataSource.h"

@implementation ReaderTabBarController

- (id)init {
    self = [super init];
    if (self) {        
        UIPageViewController *todayTab = [[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                        options:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:UIPageViewControllerSpineLocationMin]
                                                                                                                            forKey:UIPageViewControllerOptionSpineLocationKey]]
                                          autorelease];
        [todayTab setViewControllers:[NSArray arrayWithObject:[ReadingViewController controllerWithDataSource:[TodaysReadingDataSource dataSource]]]
                           direction:UIPageViewControllerNavigationDirectionForward
                            animated:NO
                          completion:nil];

        UIPageViewController *nextUnreadTab = [[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal 
                                                                                             options:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:UIPageViewControllerSpineLocationMin]
                                                                                                                                 forKey:UIPageViewControllerOptionSpineLocationKey]]
                                               autorelease];
        [nextUnreadTab setViewControllers:[NSArray arrayWithObject:[ReadingViewController controllerWithDataSource:[NextUnreadReadingDataSource dataSource]]]
                           direction:UIPageViewControllerNavigationDirectionForward
                            animated:NO
                          completion:nil];

        self.viewControllers = [NSArray arrayWithObjects:
                                todayTab,
                                nextUnreadTab,
                                nil];
    }
    return self;
}

@end
