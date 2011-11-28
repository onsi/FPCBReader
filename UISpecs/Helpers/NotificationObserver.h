#import <Foundation/Foundation.h>

@interface NotificationObserver : NSObject

@property (nonatomic, retain) NSNotification *notification;
@property (nonatomic, atomic) int notificationCount;

+ (NotificationObserver *)observerForNotificationNamed:(NSString *)notificationName;

@end
