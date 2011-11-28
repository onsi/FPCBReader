#import "Reader.h"

@interface Reader ()

@property (nonatomic, retain, readwrite) DataManager *dataManager;

@end

@implementation Reader

@synthesize
    dataManager = dataManager_;

- (id)init {
    self = [super init];
    if (self) {
        self.dataManager = [[[DataManager alloc] init] autorelease];
    }
    
    return self;
}

- (void)dealloc {
    self.dataManager = nil;
    [super dealloc];
}


@end
