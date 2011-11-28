#import "DataManager.h"

@interface DataManager ()

@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)setUpCoreData;
- (void)addPersistentStore;

@end

@implementation DataManager

@synthesize
    managedObjectContext = managedObjectContext_,
    managedObjectModel = managedObjectModel_,
    persistentStoreCoordinator = persistentStoreCoordinator_;


- (id)init {
    self = [super init];
    if (self) {
        [self setUpCoreData];
    }
    return self;
}

- (void)dealloc {
    self.managedObjectContext = nil;
    self.managedObjectModel = nil;
    self.persistentStoreCoordinator = nil;
    [super dealloc];
}

- (void)saveContext {
    if ([self.managedObjectContext hasChanges]) {
        [self.managedObjectContext save:NULL];
    } 
}

- (void)setUpCoreData {
    self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle mainBundle]]];        
    self.persistentStoreCoordinator = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel] autorelease];
    [self addPersistentStore];
    self.managedObjectContext = [[[NSManagedObjectContext alloc] init] autorelease];
    [self.managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
}

- (void)addPersistentStore {
    [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                                  configuration:nil 
                                                            URL:[self.applicationDocumentsDirectory URLByAppendingPathComponent:@"FPCBReader.sqlite"]
                                                        options:nil 
                                                          error:NULL];
}


- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
