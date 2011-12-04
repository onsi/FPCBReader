#import "NavigationReadingViewController.h"

@implementation NavigationReadingViewController

+ (NavigationReadingViewController *)navigationControllerWithDataSource:(id<ReadingDataSource>)dataSource {
    
    NavigationReadingViewController *controller = (NavigationReadingViewController *)[self controllerWithDataSource:dataSource];
    
    return controller;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.backButton.hidden = NO;
    CGRect buttonFrame = self.backButton.frame;
    CGRect referenceFrame = self.referenceLabel.frame;
    CGRect dateFrame = self.dateLabel.frame;
    if (referenceFrame.origin.x <= buttonFrame.origin.x + buttonFrame.size.width) {
        int dx = buttonFrame.origin.x + buttonFrame.size.width + 2 - referenceFrame.origin.x;
        self.referenceLabel.frame = CGRectMake(referenceFrame.origin.x + dx, referenceFrame.origin.y, referenceFrame.size.width - dx, referenceFrame.size.height);
        self.dateLabel.frame = CGRectMake(dateFrame.origin.x + dx, dateFrame.origin.y, dateFrame.size.width - dx, dateFrame.size.height);
    }
    [super viewWillAppear:animated];
}

- (void)didTapBackButton {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
