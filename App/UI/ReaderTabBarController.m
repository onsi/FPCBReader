#import "ReaderTabBarController.h"
#import "NSDate+FPCBReader.h"
#import "ReadingViewController.h"
#import "TodaysReadingDataSource.h"
#import "NextUnreadReadingDataSource.h"
#import "AllReadingsTableViewController.h"
#import "SettingsController.h"

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
        
        todayTab.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Today"
                                                             image:nil 
                                                               tag:1] autorelease];
        
        UIPageViewController *nextUnreadTab = [[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal 
                                                                                             options:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:UIPageViewControllerSpineLocationMin]
                                                                                                                                 forKey:UIPageViewControllerOptionSpineLocationKey]]
                                               autorelease];
        [nextUnreadTab setViewControllers:[NSArray arrayWithObject:[ReadingViewController controllerWithDataSource:[NextUnreadReadingDataSource dataSource]]]
                                direction:UIPageViewControllerNavigationDirectionForward
                                 animated:NO
                               completion:nil];
        
        nextUnreadTab.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Unread"
                                                                  image:nil 
                                                                    tag:2] autorelease];
        
        
        UINavigationController *allTab = [[[UINavigationController alloc] initWithRootViewController:[AllReadingsTableViewController controller]] autorelease];
        
        
        allTab.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"All"
                                                           image:nil 
                                                             tag:3] autorelease];
        
        SettingsController *settingsTab = [SettingsController controller];
        settingsTab.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Settings"
                                                                image:nil 
                                                                  tag:4] autorelease];
        
        
        self.viewControllers = [NSArray arrayWithObjects:
                                todayTab,
                                nextUnreadTab,
                                allTab,
                                settingsTab,
                                nil];
        
        
    }
    return self;
}

@end
