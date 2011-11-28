#import "NotificationObserver.h"

@implementation NotificationObserver

@synthesize 
    notification = notification_,
    notificationCount = notificationCount_;

+ (NotificationObserver *)observerForNotificationNamed:(NSString *)notificationName {
    NotificationObserver *observer = [[[NotificationObserver alloc] init] autorelease];
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:@selector(didReceiveNotification:)
                                                 name:notificationName
                                               object:nil];
    return observer;
}

- (void)didReceiveNotification:(NSNotification *)notification {
    self.notification = notification;
    self.notificationCount++;
}

- (void)dealloc {
    self.notification = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


@end
