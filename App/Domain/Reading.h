#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CachedPassage;

@interface Reading : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * reference;

+ (void)populateReadings;

+ (NSArray *)readings;
+ (Reading *)todaysReading;
+ (Reading *)nextUnreadReading;
+ (Reading *)readingForDate:(NSDate *)date;

- (CachedPassage *)passage;

- (BOOL)toggleReadingState;
- (void)markAsRead;
- (void)markAsUnread;

@end
