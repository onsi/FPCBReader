#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Passage.h"

@interface CachedPassage : NSManagedObject <Passage>

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *reference;

+ (CachedPassage *)passageForReference:(NSString *)reference;

@end