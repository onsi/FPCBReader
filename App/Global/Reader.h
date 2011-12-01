#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface Reader : NSObject

@property (nonatomic, retain, readonly) DataManager *dataManager;

- (void)performSetUp;
- (NSString *)htmlFormatContent:(NSString *)content;

@end

extern Reader *reader;