#import "Reading.h"
#import "Reader.h"
#import "CachedPassage.h"
#import "NSDate+FPCBReader.h"

@implementation Reading

@dynamic date;
@dynamic isRead;
@dynamic reference;

+ (void)populateReadings {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reading"];
    NSUInteger count = [reader.dataManager.managedObjectContext countForFetchRequest:request error:NULL];
    
    if (count == NSNotFound || count == 0) {
        NSURL *url = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"ReadingPlan.plist"];
        NSArray *readings = [NSArray arrayWithContentsOfURL:url];
        for (NSDictionary *readingDictionary in readings) {
            Reading *reading = [NSEntityDescription insertNewObjectForEntityForName:@"Reading"
                                                             inManagedObjectContext:reader.dataManager.managedObjectContext];
            
            
            int year = [[readingDictionary objectForKey:@"year"] intValue];
            int month = [[readingDictionary objectForKey:@"month"] intValue];
            int day = [[readingDictionary objectForKey:@"day"] intValue];
            
            NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
            components.year = year;
            components.month = month;
            components.day = day;
            
            reading.date = [[NSCalendar currentCalendar] dateFromComponents:components];
            reading.reference = [readingDictionary objectForKey:@"reference"];
        }
        [reader.dataManager saveContext];
    }
}

+ (NSArray *)readings {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reading"];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    return [reader.dataManager.managedObjectContext executeFetchRequest:request error:NULL];
}

+ (Reading *)todaysReading {
    return [self readingForDate:[NSDate date]];
}

+ (Reading *)nextUnreadReading {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reading"];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"isRead = NO"]];
    [request setFetchLimit:1];
    return [[reader.dataManager.managedObjectContext executeFetchRequest:request error:NULL] lastObject];
}

+ (Reading *)readingForDate:(NSDate *)date {
    NSDate *trimmedDate = [date dateByRemovingTimeComponent];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reading"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"date = %@", trimmedDate]];
    return [[reader.dataManager.managedObjectContext executeFetchRequest:request error:NULL] lastObject];
}

- (CachedPassage *)passage {
    return [CachedPassage passageForReference:self.reference];
}

- (BOOL)toggleReadingState {
    self.isRead = [NSNumber numberWithBool:!self.isRead.boolValue];
    [reader.dataManager.managedObjectContext save:NULL];
    return self.isRead.boolValue;
}

- (void)markAsRead {
    self.isRead = [NSNumber numberWithBool:YES];
    [reader.dataManager.managedObjectContext save:NULL];
}

- (void)markAsUnread {
    self.isRead = [NSNumber numberWithBool:NO];
    [reader.dataManager.managedObjectContext save:NULL];
}

@end
