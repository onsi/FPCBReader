#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface Reader : NSObject

@property (nonatomic, retain, readonly) DataManager *dataManager;

@end

extern Reader *reader;