#import "SpecEnvironment.h"
Reader *reader;

static BOOL didSetupReadingPlist;
static NSTimeInterval today;

@interface SpecEnvironment ()

+ (void)setUpReadingPlist;

@end

@implementation SpecEnvironment

+ (void)beforeEach {
    reader = [[[Reader alloc] init] autorelease];

    if (!didSetupReadingPlist) {
        [self setUpReadingPlist];
    }
    
    [reader performSetUp];
}

+ (void)setUpReadingPlist {
    NSMutableArray *readings = [NSMutableArray array];
    
    NSDateComponents *components;
    
    components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit
                                                 fromDate:self.yesterday];
    [readings addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:components.year], @"year",
                         [NSNumber numberWithInt:components.month], @"month",
                         [NSNumber numberWithInt:components.day], @"day",                         
                         @"John 1", @"reference",
                         nil]];

    components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit
                                                 fromDate:self.tomorrow];
    [readings addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:components.year], @"year",
                         [NSNumber numberWithInt:components.month], @"month",
                         [NSNumber numberWithInt:components.day], @"day",                         
                         @"John 3", @"reference",
                         nil]];
    
    components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit
                                                 fromDate:self.today];
    [readings addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:components.year], @"year",
                         [NSNumber numberWithInt:components.month], @"month",
                         [NSNumber numberWithInt:components.day], @"day",                         
                         @"John 2", @"reference",
                         nil]];

    NSURL *url = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"ReadingPlan.plist"];
    [readings writeToURL:url
              atomically:YES];
    
    didSetupReadingPlist = YES;
}

+ (NSDate *)today {    
    if (!today) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit
                                                                       fromDate:[NSDate date]];
        NSDate *todaysDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        today = floor([todaysDate timeIntervalSince1970]);
    }
    return [NSDate dateWithTimeIntervalSince1970:today];
}

+ (NSDate *)tomorrow {
    return [self.today dateByAddingTimeInterval:24*3600];
}

+ (NSDate *)yesterday {
    return [self.today dateByAddingTimeInterval:-24*3600];
}

@end

@implementation DataManager (SpecInMemoryImplementation)

- (void)addPersistentStore {
    [self.persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType 
                                                  configuration:nil 
                                                            URL:nil
                                                        options:nil 
                                                          error:NULL];
}

@end