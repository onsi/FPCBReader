#import "NSDate+FPCBReader.h"

@implementation NSDate (FPCBReader)

- (NSDate *)dateByRemovingTimeComponent {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit
                                                                   fromDate:self];
    return [[NSCalendar currentCalendar] dateFromComponents:components];    
}

- (NSString *)readerFormat {
    return [NSDateFormatter localizedStringFromDate:self
                                          dateStyle:NSDateFormatterLongStyle
                                          timeStyle:NSDateFormatterNoStyle];
}

@end
