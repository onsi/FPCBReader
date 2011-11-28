#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CachedPassage : NSManagedObject

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *reference;

+ (CachedPassage *)passageForReference:(NSString *)reference;

@end