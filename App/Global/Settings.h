#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Settings : NSManagedObject

@property (nonatomic, retain) NSNumber * invert;
@property (nonatomic, retain) NSNumber * fontSize;

+ (Settings *)settings;

@end
