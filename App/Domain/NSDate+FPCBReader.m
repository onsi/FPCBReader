#import "NSDate+FPCBReader.h"

@implementation NSDate (FPCBReader)

- (NSDate *)dateByRemovingTimeComponent {
    //Extract the components from the passed in date.  These are in the current time zone
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit
                                                                   fromDate:self];
    components.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return [[NSCalendar currentCalendar] dateFromComponents:components]; //returns the date in the GMT time zone
}

- (NSString *)readerFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString *result = [formatter stringForObjectValue:self];
    return result;
}

@end
