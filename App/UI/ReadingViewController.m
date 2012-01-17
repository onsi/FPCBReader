#import "ReadingViewController.h"
#import "NSDate+FPCBReader.h"
#import "Reading.h"
#import "Passage.h"
#import "Reader.h"

@interface ReadingViewController ()

@property (nonatomic, retain) id<ReadingDataSource> dataSource;
@property (nonatomic, retain) id<Passage> passage;
- (void)refresh;
- (void)refreshReadButton;
- (void)refreshColors;

@end

@implementation ReadingViewController

@synthesize
    dataSource = dataSource_,
    passage = passage_,
    dateLabel = dateLabel_,
    referenceLabel = referenceLabel_,
    toggleReadStateButton = toggleReadStateButton_,
    containerView = containerView_,
    loadingView = loadingView_,
    retryView = retryView_,
    finishedReadingsView = finishedReadingsView_,
    retryButton = retryButton_,
    contentWebView = contentWebView_,
    backButton = backButton_,
    topGradient = topGradient_,
    bottomGradient = bottomGradient_;

+ (ReadingViewController *)controllerWithDataSource:(id<ReadingDataSource>)dataSource {
    ReadingViewController *controller = [[[self alloc] initWithNibName:@"ReadingViewController" bundle:nil] autorelease];
    controller.dataSource = dataSource;
    return controller;
}

- (void)dealloc {
    self.passage = nil;
    self.dataSource = nil;
    self.loadingView = nil;
    self.retryView = nil;
    self.contentWebView = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
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
    self.dateLabel.text = self.dataSource.reading.date.readerFormat;
    self.referenceLabel.text = self.dataSource.reading.reference;
    
    [self.containerView.subviews.lastObject removeFromSuperview];
    
    self.passage = self.dataSource.reading.passage;
    
    if (self.passage) {
        if (self.passage.content) {
            self.contentWebView.hidden = YES;
            [self.contentWebView loadHTMLString:[reader htmlFormatContent:self.passage.content] baseURL:nil];
            [self.containerView addSubview:self.contentWebView];
        } else {
            [self.containerView addSubview:self.loadingView];
        }
    } else {
        [self.containerView addSubview:self.finishedReadingsView];
    }
    [self refreshReadButton];
    [self refreshColors];
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
        [self refreshColors];
    }
}

- (void)refreshColors {
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

}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return navigationType == UIWebViewNavigationTypeOther;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.hidden = NO;
}

- (void)didTapToggleReadStateButton {
    Reading *reading = self.dataSource.reading;
    [reading toggleReadingState];
    [self refreshReadButton];
    if (![self.dataSource.reading isEqual:reading]) {
        [(UIPageViewController *)self.parentViewController setViewControllers:[NSArray arrayWithObject:[ReadingViewController controllerWithDataSource:self.dataSource]]
                                                                    direction:UIPageViewControllerNavigationDirectionForward
                                                                     animated:YES
                                                                   completion:nil];
    }
}

- (void)refreshReadButton {
    NSString *imageName;
    if (self.dataSource.reading.isRead.boolValue) {
        imageName = @"Read.png";
    } else {
        imageName = @"Unread.png";        
    }
    [self.toggleReadStateButton setImage:[UIImage imageNamed:imageName] 
                                forState:UIControlStateNormal];
    self.toggleReadStateButton.enabled = (self.containerView.subviews.lastObject == self.contentWebView);
}

- (void)didTapBackButton {
}

@end
