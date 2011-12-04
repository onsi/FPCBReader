#import <UIKit/UIKit.h>
#import "ReadingDataSource.h"

@class Reading;

@interface ReadingViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, assign) IBOutlet UILabel *dateLabel;
@property (nonatomic, assign) IBOutlet UILabel *referenceLabel;
@property (nonatomic, assign) IBOutlet UIButton *toggleReadStateButton;

@property (nonatomic, assign) IBOutlet UIView *containerView;

@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) IBOutlet UIView *retryView;
@property (nonatomic, retain) IBOutlet UIView *finishedReadingsView;
@property (nonatomic, assign) IBOutlet UIButton *retryButton;

@property (nonatomic, retain) IBOutlet UIWebView *contentWebView;
@property (nonatomic, assign) IBOutlet UIButton *backButton;


+ (ReadingViewController *)controllerWithDataSource:(id<ReadingDataSource>)dataSource;

- (IBAction)didTapRetryButton;
- (IBAction)didTapToggleReadStateButton;
- (IBAction)didTapBackButton;

@end