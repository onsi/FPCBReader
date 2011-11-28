#import "Reader.h"

@interface Reader ()

@property (nonatomic, retain, readwrite) DataManager *dataManager;
@property (nonatomic, retain, readwrite) Passages *passages;

@end

@implementation Reader

@synthesize
    dataManager = dataManager_,
    passages = passages_;

- (id)init {
    self = [super init];
    if (self) {
        self.dataManager = [[[DataManager alloc] init] autorelease];
        self.passages = [[[Passages alloc] init] autorelease];
    }
    
    return self;
}

- (void)dealloc {
    self.passages = nil;
    self.dataManager = nil;
    [super dealloc];
}


@end
