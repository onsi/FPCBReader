#import "ReaderSplitViewController.h"
#import "MasterController.h"
#import "DetailController.h"

@implementation ReaderSplitViewController

- (id)init {
    self = [super init];
    if (self) {
        MasterController *masterController = [MasterController controller];
        self.viewControllers = [NSArray arrayWithObjects:masterController, masterController.detailController, nil];
    }
    
    return self;
}

@end