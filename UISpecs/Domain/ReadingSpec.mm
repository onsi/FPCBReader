#import <Cedar-iPhone/SpecHelper.h>
using namespace Cedar::Matchers;

#import "Reading.h"
#import "CachedPassage.h"
#import "SpecEnvironment.h"

SPEC_BEGIN(ReadingSpec)

describe(@"Reading", ^{
    describe(@"populateReadings (called by globalState)", ^{
        it(@"should populate the readings from a plist", ^{
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reading"];
            [reader.dataManager.managedObjectContext countForFetchRequest:request error:NULL] should equal(3);
        });
            
        context(@"when the readings are already present", ^{
            it(@"should not repopulate the readings", ^{
                [Reading populateReadings];
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reading"];
                [reader.dataManager.managedObjectContext countForFetchRequest:request error:NULL] should equal(3);
            });
        });
    });
    
    describe(@"readings", ^{
        it(@"should return an array of readings ordered by date.", ^{
            NSArray *readings = [Reading readings];
            readings.count should equal(3);

            [[readings objectAtIndex:0] date] should equal([[SpecEnvironment yesterday] dateByRemovingTimeComponent]);
            [[readings objectAtIndex:0] reference] should equal(@"John 1");
            
            [[readings objectAtIndex:1] date] should equal([[SpecEnvironment today] dateByRemovingTimeComponent]);
            [[readings objectAtIndex:1] reference] should equal(@"John 2");

            [[readings objectAtIndex:2] date] should equal([[SpecEnvironment tomorrow] dateByRemovingTimeComponent]);            
            [[readings objectAtIndex:2] reference] should equal(@"John 3");
        });
    });
    
    describe(@"todaysReading", ^{
        it(@"should return today's reading", ^{
            Reading *reading = [Reading todaysReading];
            [reading reference] should equal(@"John 2");
            [reading markAsRead];

            [[Reading todaysReading] reference] should equal(@"John 2");
            
            [reader.dataManager.managedObjectContext deleteObject:reading];
            [reader.dataManager saveContext];

            [Reading todaysReading] should be_nil();
        });
    });
    
    describe(@"nextUnreadReading", ^{
        it(@"should return the first unread reading", ^{
            Reading *reading = [Reading nextUnreadReading];
            [reading reference] should equal(@"John 1");
            [reading markAsRead];
            
            reading = [Reading nextUnreadReading];
            [reading reference] should equal(@"John 2");            
            [reading markAsRead];

            reading = [Reading nextUnreadReading];
            [reading reference] should equal(@"John 3");            
            [reading markAsRead];
            
            reading = [Reading nextUnreadReading];
            [reading reference] should be_nil();
        });
    });
    
    describe(@"readingforDate:", ^{
        it(@"should return the reading corresponding to the given date", ^{
            [Reading readingForDate:[SpecEnvironment yesterday]].reference should equal(@"John 1");
            [Reading readingForDate:[SpecEnvironment today]].reference should equal(@"John 2");
            [Reading readingForDate:[SpecEnvironment tomorrow]].reference should equal(@"John 3");

            [Reading readingForDate:[[SpecEnvironment today] dateByAddingTimeInterval:-1]].reference should equal(@"John 1");
            [Reading readingForDate:[[SpecEnvironment today] dateByAddingTimeInterval:12 * 3600]].reference should equal(@"John 2");
            [Reading readingForDate:[[SpecEnvironment today] dateByAddingTimeInterval:24 * 3600]].reference should equal(@"John 3");
        });
    });
    
    describe(@"marking/unmarking as read", ^{
        it(@"should do the obvious", ^{
            Reading *reading = [Reading todaysReading];
            reading.isRead.boolValue should_not be_truthy();
            
            [reading markAsRead];
            reading.isRead.boolValue should be_truthy();
            
            [reading markAsUnread];            
            reading.isRead.boolValue should_not be_truthy();
        });
    });
    
    describe(@"passage", ^{
        it(@"should return the associated cached passage", ^{
            [Reading todaysReading].passage should equal([CachedPassage passageForReference:@"John 2"]);
        });
    });
});

SPEC_END
