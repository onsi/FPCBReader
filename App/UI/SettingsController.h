#import <UIKit/UIKit.h>

@interface SettingsController : UIViewController <UIWebViewDelegate>

@property (nonatomic, assign) IBOutlet UISlider *fontSizeSlider;
@property (nonatomic, assign) IBOutlet UISwitch *invertSwitch;
@property (nonatomic, assign) IBOutlet UIWebView *preview;

@property (nonatomic, assign) IBOutlet UIImageView *fontSizeImageView;
@property (nonatomic, assign) IBOutlet UIImageView *brightnessImageView;

+ (SettingsController *)controller;

- (IBAction)didUpdateFontSize;
- (IBAction)didToggleInvert;

@end
