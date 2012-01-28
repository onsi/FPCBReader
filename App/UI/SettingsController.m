#import "SettingsController.h"
#import "Reader.h"

@interface SettingsController ()

- (void)refreshColorsAndFontSize;
- (void)refresh;
    
@end

@implementation SettingsController

@synthesize 
    fontSizeSlider = fontSizeSlider_,
    invertSwitch = invertSwitch_,
    preview = preview_,
    fontSizeImageView = fontSizeImageView_,
    brightnessImageView = brightnessImageView_,
    topGradient = topGradient_,
    bottomGradient = bottomGradient_;

+ (SettingsController *)controller {
    return [[[self alloc] initWithNibName:@"SettingsController" bundle:nil] autorelease];
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    self.preview.hidden = YES;
    self.preview.delegate = self;
    [self.fontSizeSlider setValue:reader.settings.fontSize.floatValue];
    [self.invertSwitch setOn:reader.settings.invert.boolValue];
    [self refresh];
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)didUpdateFontSize {
    reader.settings.fontSize = [NSNumber numberWithFloat:self.fontSizeSlider.value];
    [reader.dataManager saveContext];
    [self refreshColorsAndFontSize];
}

- (IBAction)didToggleInvert {
    reader.settings.invert = [NSNumber numberWithBool:self.invertSwitch.isOn];
    [reader.dataManager saveContext];
    [self refreshColorsAndFontSize];
}

- (void)refresh {
    [self.preview loadHTMLString:reader.preview 
                         baseURL:nil];
    [self refreshColorsAndFontSize];
}

- (void)refreshColorsAndFontSize {
    self.view.backgroundColor = reader.backgroundColor;
    self.fontSizeImageView.image = reader.fontSizeImage;
    self.brightnessImageView.image = reader.brightnessImage;
    
    self.topGradient.image = reader.topGradient;
    self.bottomGradient.image = reader.bottomGradient;

    self.preview.backgroundColor = reader.backgroundColor;
    
    [[UIApplication sharedApplication] setStatusBarStyle:reader.settings.invert.boolValue ? UIStatusBarStyleDefault : UIStatusBarStyleBlackOpaque
                                                animated:NO];    
    
    [self.preview stringByEvaluatingJavaScriptFromString:reader.javascriptToUpdateStyling];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.preview.hidden = NO;
}

- (BOOL)webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
