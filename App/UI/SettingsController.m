#import "SettingsController.h"
#import "Reader.h"

@interface SettingsController ()

- (void)refresh;
    
@end

@implementation SettingsController

@synthesize 
    fontSizeSlider = fontSizeSlider_,
    invertSwitch = invertSwitch_,
    preview = preview_;

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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)didUpdateFontSize {
    reader.settings.fontSize = [NSNumber numberWithFloat:self.fontSizeSlider.value];
    [reader.dataManager saveContext];
    [self refresh];
}

- (IBAction)didToggleInvert {
    reader.settings.invert = [NSNumber numberWithBool:self.invertSwitch.isOn];
    [reader.dataManager saveContext];
    [self refresh];
}

- (void)refresh {
    [self.preview loadHTMLString:reader.preview 
                         baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.preview.hidden = NO;
}

@end
