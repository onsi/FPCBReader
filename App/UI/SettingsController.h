#import <UIKit/UIKit.h>

@interface SettingsController : UIViewController <UIWebViewDelegate>

@property (nonatomic, assign) IBOutlet UISlider *fontSizeSlider;
@property (nonatomic, assign) IBOutlet UISwitch *invertSwitch;
@property (nonatomic, assign) IBOutlet UIWebView *preview;

+ (SettingsController *)controller;

- (IBAction)didUpdateFontSize;
- (IBAction)didToggleInvert;

@end
