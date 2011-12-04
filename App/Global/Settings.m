#import "Settings.h"
#import "Reader.h"

@implementation Settings

@dynamic invert;
@dynamic fontSize;

+ (Settings *)settings {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Settings"];
    request.fetchLimit = 1;
    Settings *settings = [[reader.dataManager.managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    if (!settings) {
        settings = [NSEntityDescription insertNewObjectForEntityForName:@"Settings"
                                                 inManagedObjectContext:reader.dataManager.managedObjectContext];
    }

    return settings;
}

@end
