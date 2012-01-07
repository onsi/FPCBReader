#import "AppDelegate.h"
#import "ReaderTabBarController.h"
#import "ReaderSplitViewController.h"
#import "Reader.h"
Reader *reader;

@interface AppDelegate ()

@property (nonatomic, retain, readwrite) Reader *reader;

@end

@implementation AppDelegate

@synthesize 
    window = _window,
    reader = reader_;

- (void)dealloc {
    reader = nil;
    self.reader = nil;
    self.window = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.reader = [[[Reader alloc] init] autorelease];
    reader = self.reader;
    [reader performSetUp];
    [[UIApplication sharedApplication] setStatusBarStyle:reader.settings.invert.boolValue ? UIStatusBarStyleDefault : UIStatusBarStyleBlackOpaque
                                                animated:NO];

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[[ReaderSplitViewController alloc] init] autorelease];        
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.reader.dataManager saveContext];
}

@end
