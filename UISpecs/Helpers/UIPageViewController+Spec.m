#import "UIPageViewController+Spec.h"
#import <objc/runtime.h>

@implementation UIPageViewController (Spec)

+ (UIPageViewController *)pageViewControllerWithController:(UIViewController *)controller {
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:UIPageViewControllerSpineLocationMin] 
                                                        forKey:UIPageViewControllerOptionSpineLocationKey];
    
    UIPageViewController *pageViewController = [[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                                                navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                              options:options] autorelease];
    [pageViewController setViewControllers:[NSArray arrayWithObject:controller]
                                 direction:UIPageViewControllerNavigationDirectionForward
                                  animated:NO
                                completion:nil];
    
    return pageViewController;
}

@end
