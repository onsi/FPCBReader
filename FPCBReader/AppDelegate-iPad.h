#import <UIKit/UIKit.h>

@class Reader;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain, readonly) Reader *reader;
@property (strong, nonatomic) UIWindow *window;

@end
