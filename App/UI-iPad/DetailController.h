#import <UIKit/UIKit.h>

@class Reading, MasterController;

@interface DetailController : UIViewController <UIWebViewDelegate>

@property (nonatomic, assign) IBOutlet UILabel *dateLabel;
@property (nonatomic, assign) IBOutlet UILabel *referenceLabel;
@property (nonatomic, assign) IBOutlet UIButton *toggleReadStateButton;

@property (nonatomic, assign) IBOutlet UIView *containerView;

@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) IBOutlet UIView *retryView;
@property (nonatomic, assign) IBOutlet UIButton *retryButton;

@property (nonatomic, retain) IBOutlet UIWebView *contentWebView;

@property (nonatomic, retain) IBOutlet UIImageView *topGradient;
@property (nonatomic, retain) IBOutlet UIImageView *bottomGradient;

@property (nonatomic, assign) Reading *reading;

+ (DetailController *)controller;

- (IBAction)didTapRetryButton;
- (IBAction)didTapToggleReadStateButton;
- (void)refresh;
- (void)refreshColorsAndFontSize;

@end
