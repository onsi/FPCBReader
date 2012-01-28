#import "DetailController.h"
#import "NSDate+FPCBReader.h"
#import "Reading.h"
#import "Passage.h"
#import "Reader.h"

@interface DetailController ()

@property (nonatomic, retain) id<Passage> passage;
- (void)refreshReadButton;

@end

@implementation DetailController

@synthesize
    passage = passage_,
    dateLabel = dateLabel_,
    referenceLabel = referenceLabel_,
    toggleReadStateButton = toggleReadStateButton_,
    containerView = containerView_,
    loadingView = loadingView_,
    retryView = retryView_,
    retryButton = retryButton_,
    contentWebView = contentWebView_,
    reading = reading_,
    topGradient = topGradient_,
    bottomGradient = bottomGradient_;

+ (DetailController *)controller {
    DetailController *controller = [[[self alloc] initWithNibName:@"DetailController" bundle:nil] autorelease];
    return controller;
}

- (void)dealloc {
    self.passage = nil;
    self.loadingView = nil;
    self.retryView = nil;
    self.contentWebView = nil;
    self.reading = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)setReading:(Reading *)reading {
    [reading_ removeObserver:self forKeyPath:@"isRead"];
    reading_ = reading;
    [reading_ addObserver:self
               forKeyPath:@"isRead"
                  options:0
                  context:nil];
    [self refresh];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self refreshReadButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDownloadPassage:) name:@"didDownloadPassage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDidFail:) name:@"downloadDidFail" object:nil];
    [self refresh];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self]; 
}

- (void)refresh {
    self.dateLabel.text = self.reading.date.readerFormat;
    self.referenceLabel.text = self.reading.reference;
    
    [self.containerView.subviews.lastObject removeFromSuperview];
    
    self.passage = self.reading.passage;
    if (self.passage) {
        if (self.passage.content) {
            self.contentWebView.hidden = YES;
            [self.contentWebView loadHTMLString:[reader htmlFormatContent:self.passage.content] baseURL:nil];
            [self.containerView addSubview:self.contentWebView];
        } else {
            [self.containerView addSubview:self.loadingView];
        }
    }
    [self refreshReadButton];
    [self refreshColorsAndFontSize];
}

- (IBAction)didTapRetryButton {
    [self refresh];
}

#pragma mark Notification callbacks
- (void)didDownloadPassage:(NSNotification *)notification {
    if ([notification.object isEqual:self.passage]) {
        [self refresh];
    }
}

- (void)downloadDidFail:(NSNotification *)notification {
    if ([notification.object isEqual:self.passage]) {
        [self.containerView.subviews.lastObject removeFromSuperview];
        [self.containerView addSubview:self.retryView];
        [self refreshColorsAndFontSize];
    }
}

- (void)refreshColorsAndFontSize {
    self.view.backgroundColor = reader.backgroundColor;
    self.dateLabel.textColor = reader.textColor;
    self.referenceLabel.textColor = reader.textColor;
    self.topGradient.image = reader.topGradient;
    self.bottomGradient.image = reader.bottomGradient;
    [self.containerView.subviews.lastObject setBackgroundColor:reader.backgroundColor];
    for (UIView *view in [self.containerView.subviews.lastObject subviews]) {
        if ([view respondsToSelector:@selector(setTextColor:)]) {
            [(id)view setTextColor:reader.textColor];
        }
    }
    
    if ([self.containerView.subviews.lastObject isEqual:self.contentWebView]) {
        [self.contentWebView stringByEvaluatingJavaScriptFromString:reader.javascriptToUpdateStyling];
    }
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return navigationType == UIWebViewNavigationTypeOther;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.hidden = NO;
}

- (void)didTapToggleReadStateButton {
    [self.reading toggleReadingState];
    [self refreshReadButton];
}

- (void)refreshReadButton {
    NSString *imageName;
    if (self.reading.isRead.boolValue) {
        imageName = @"Read.png";
    } else {
        imageName = @"Unread.png";        
    }
    [self.toggleReadStateButton setImage:[UIImage imageNamed:imageName] 
                                forState:UIControlStateNormal];
    self.toggleReadStateButton.enabled = (self.containerView.subviews.lastObject == self.contentWebView);
}

@end
