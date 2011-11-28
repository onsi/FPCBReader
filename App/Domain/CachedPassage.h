#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CachedPassage : NSManagedObject

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *reference;

+ (CachedPassage *)passageWithReference:(NSString *)reference
                              content:(NSString *)content;
+ (CachedPassage *)passageForReference:(NSString *)reference;
+ (CachedPassage *)oldestPassage;

- (void)save;

@end