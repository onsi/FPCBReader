#import "UIPageViewController+Spec.h"
#import <objc/runtime.h>

//static char viewControllersKey;

//@interface UIPageViewController (Spec_Private)
//
//@property (nonatomic, retain, readwrite) NSArray *viewControllers;
//
//@end

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

//- (NSArray *)viewControllers {
//    return objc_getAssociatedObject(self, &viewControllersKey);
//}
//
//- (void)setViewControllers:(NSArray *)viewControllers {
//    objc_setAssociatedObject(self, &viewControllersKey, viewControllers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (void)setViewControllers:(NSArray *)viewControllers direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL))completion {
//    //assumes just one view controller passed in
//    NSLog(@"================> %@", viewControllers);
//    self.viewControllers = viewControllers;
//    if (completion) {
//        completion(animated);
//    }
//}

@end
