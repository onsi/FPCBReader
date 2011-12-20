#import <UIKit/UIKit.h>

@class DetailController;

@interface MasterController : UIViewController

@property (nonatomic, retain) DetailController *detailController;
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) IBOutlet UISlider *fontSizeSlider;
@property (nonatomic, assign) IBOutlet UISwitch *invert;
@property (nonatomic, assign) IBOutlet UIToolbar *topToolbar;

@property (nonatomic, assign) IBOutlet UIImageView *fontSizeImageView;
@property (nonatomic, assign) IBOutlet UIImageView *brightnessImageView;

+ (MasterController *)controller;

- (IBAction)didTapTodayButton;
- (IBAction)didTapUnreadButton;
- (IBAction)didUpdateFontSize;
- (IBAction)didToggleInvert;

@end
