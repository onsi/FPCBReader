#import <Cedar-iPhone/SpecHelper.h>
using namespace Cedar::Matchers;

#import "AllReadingsTableViewController.h"
#import "ReadingCell.h"
#import "SpecEnvironment.h"
#import "Reading.h"
#import "NavigationReadingViewController.h"
#import "UIWebView+Spec.h"
#import "NSURLConnection+Spec.h"
#import "CachedPassage+Spec.h"

SPEC_BEGIN(AllReadingsTableViewControllerSpec)

describe(@"AllReadingsTableViewController", ^{
    __block AllReadingsTableViewController *controller;
    __block UINavigationController *navigation;
    __block UITableView *tableView;
    
    beforeEach(^{
        controller = [AllReadingsTableViewController controller];
        navigation = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
        controller.view should_not be_nil();
        tableView = controller.tableView;
        [tableView reloadData];
    });
    
    describe(@"displaying the table", ^{
        it(@"should have one section filled with cells for all readings, in the right order", ^{
            tableView.numberOfSections should equal(1);
            [tableView numberOfRowsInSection:0] should equal(3);
           
            ReadingCell *yesterdayCell = (ReadingCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            ReadingCell *todayCell = (ReadingCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            ReadingCell *tomorrowCell = (ReadingCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];

            yesterdayCell.dateLabel.text should equal(SpecEnvironment.yesterday.readerFormat);
            yesterdayCell.readingLabel.text should equal(@"John 1");
            [yesterdayCell.toggleReadStateButton imageForState:UIControlStateNormal] should equal([UIImage imageNamed:@"Unread.png"]);
            
            todayCell.dateLabel.text should equal(SpecEnvironment.today.readerFormat);
            todayCell.readingLabel.text should equal(@"John 2");
            [todayCell.toggleReadStateButton imageForState:UIControlStateNormal] should equal([UIImage imageNamed:@"Unread.png"]);
            
            tomorrowCell.dateLabel.text should equal(SpecEnvironment.tomorrow.readerFormat);
            tomorrowCell.readingLabel.text should equal(@"John 3");
            [tomorrowCell.toggleReadStateButton imageForState:UIControlStateNormal] should equal([UIImage imageNamed:@"Unread.png"]);
        });
    });
    
    describe(@"tapping the read/unread buttons", ^{
        it(@"should mark the relevant passage as read/unread", ^{
            ReadingCell *todayCell = (ReadingCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            Reading *reading = [Reading readingForDate:SpecEnvironment.today];
            
            [todayCell.toggleReadStateButton imageForState:UIControlStateNormal] should equal([UIImage imageNamed:@"Unread.png"]);
            reading.isRead.boolValue should_not be_truthy();
            
            [todayCell.toggleReadStateButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            [todayCell.toggleReadStateButton imageForState:UIControlStateNormal] should equal([UIImage imageNamed:@"Read.png"]);
            reading.isRead.boolValue should be_truthy();
            
            [todayCell.toggleReadStateButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            [todayCell.toggleReadStateButton imageForState:UIControlStateNormal] should equal([UIImage imageNamed:@"Unread.png"]);
            reading.isRead.boolValue should_not be_truthy();
        });
    });
    
    describe(@"tapping a cell", ^{
        it(@"should push a Reading controller", ^{
            [controller tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            Reading *reading = [Reading readingForDate:SpecEnvironment.today];

            NavigationReadingViewController *readingController = (NavigationReadingViewController *)navigation.topViewController;
            readingController.view should_not be_nil();
            [readingController viewWillAppear:YES];
            
            readingController.dateLabel.text should equal(SpecEnvironment.today.readerFormat);
            readingController.referenceLabel.text should equal(@"John 2");
            [readingController.toggleReadStateButton imageForState:UIControlStateNormal] should equal([UIImage imageNamed:@"Unread.png"]);
            
            readingController.containerView.subviews.lastObject should equal(readingController.loadingView);
            
            [NSURLConnection provideSuccesfulResponse:@"On the third day..." forURL:reading.passage.url];
            
            readingController.containerView.subviews.lastObject should equal(readingController.contentWebView);
            readingController.contentWebView.loadedHTMLString should contain(@"On the third day...");
            
            [readingController.toggleReadStateButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            [readingController.toggleReadStateButton imageForState:UIControlStateNormal] should equal([UIImage imageNamed:@"Read.png"]);
            
            readingController.backButton.hidden should_not be_truthy();
            [readingController.backButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            navigation.topViewController should equal(controller);
            
            ReadingCell *todayCell = (ReadingCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [todayCell.toggleReadStateButton imageForState:UIControlStateNormal] should equal([UIImage imageNamed:@"Read.png"]);
        });
    });
});

SPEC_END
