#import "ReadingViewController.h"
#import "NSDate+FPCBReader.h"
#import "Reading.h"
#import "CachedPassage.h"
#import "Reader.h"

@interface ReadingViewController ()

@property (nonatomic, retain) id<ReadingDataSource> dataSource;
@property (nonatomic, retain) CachedPassage *passage;
- (void)refresh;
- (void)refreshReadButton;

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
    contentWebView = contentWebView_;

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

- (UITabBarItem *)tabBarItem {
    return [[[UITabBarItem alloc] initWithTitle:self.dataSource.tabItemTitle
                                          image:nil 
                                            tag:0] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
    self.contentWebView.backgroundColor = [UIColor blackColor];
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
            [self.contentWebView loadHTMLString:[reader htmlFormatContent:self.passage.content] baseURL:nil];
            [self.containerView addSubview:self.contentWebView];
        } else {
            [self.containerView addSubview:self.loadingView];
        }
    } else {
        [self.containerView addSubview:self.finishedReadingsView];
    }
    [self refreshReadButton];
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
    }
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return navigationType == UIWebViewNavigationTypeOther;
}

- (void)didTapToggleReadStateButton {
    Reading *reading = self.dataSource.reading;
    [reading toggleReadingState];
    [self refreshReadButton];
    if (![self.dataSource.reading isEqual:reading]) {
        [self refresh];
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

@end
