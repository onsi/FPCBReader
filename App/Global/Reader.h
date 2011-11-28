#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "Passages.h"

@interface Reader : NSObject

@property (nonatomic, retain, readonly) DataManager *dataManager;
@property (nonatomic, retain, readonly) Passages *passages;

@end

extern Reader *reader;