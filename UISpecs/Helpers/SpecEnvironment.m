#import "SpecEnvironment.h"
#import "NSDate+FPCBReader.h"
#import "UncachedPassage.h"
Reader *reader;

NSString *SECRET_KEY = @"SPEC_KEY";

static BOOL didSetupReadingPlist;
static NSTimeInterval today;

@interface UncachedPassage (SpecEnvironment)

+ (void)resetCache;

@end


@interface SpecEnvironment ()

+ (void)setUpReadingPlist;

@end

@implementation SpecEnvironment

+ (void)beforeEach {
    [UncachedPassage resetCache];
    reader = [[[Reader alloc] init] autorelease];

    if (!didSetupReadingPlist) {
        [self setUpReadingPlist];
    }
    
    [reader performSetUp];
}

+ (void)setUpReadingPlist {
    NSMutableArray *readings = [NSMutableArray array];
    
    NSDateComponents *components;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit
                             fromDate:self.yesterday];
    
    [readings addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:components.year], @"year",
                         [NSNumber numberWithInt:components.month], @"month",
                         [NSNumber numberWithInt:components.day], @"day",                         
                         @"John 1", @"reference",
                         nil]];

    components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit
                                                 fromDate:self.tomorrow];
    [readings addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:components.year], @"year",
                         [NSNumber numberWithInt:components.month], @"month",
                         [NSNumber numberWithInt:components.day], @"day",                         
                         @"John 3", @"reference",
                         nil]];
    
    components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit
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
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];

        today = floor(date.timeIntervalSince1970);
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:today];
    return date;
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