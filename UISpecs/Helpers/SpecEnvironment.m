#import "Reader.h"
Reader *reader;

@interface SpecEnvironment : NSObject
@end

@implementation SpecEnvironment

+ (void)beforeEach {
    reader = [[[Reader alloc] init] autorelease];
}

@end

@implementation DataManager (SpecInMemoryImplementation)

- (void)addPersistentStore {
    [self.persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType 
                                                  configuration:nil 
                                                            URL:nil
                                                        options:nil 
                                                          error:NULL];
}

@end