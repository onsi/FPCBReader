#import <Cedar-iPhone/SpecHelper.h>
using namespace Cedar::Matchers;

#import "ReadingViewController.h"
#import "NextUnreadReadingDataSource.h"
#import "Reading.h"
#import "SpecEnvironment.h"
#import "CachedPassage+Spec.h"
#import "UIWebView+Spec.h"
#import "NSURLConnection+Spec.h"

SPEC_BEGIN(NextUnread_ReadingViewControllerSpec)

describe(@"ReadingViewController", ^{
    __block ReadingViewController *controller;
    __block NextUnreadReadingDataSource *dataSource;
    
    beforeEach(^{
		dataSource = [NextUnreadReadingDataSource dataSource];
        controller = [ReadingViewController controllerWithDataSource:dataSource];
        controller.view should_not be_nil();
    });
    
    describe(@"tabBarItem", ^{
        it(@"should have the correct tab bar item", ^{
            controller.tabBarItem.title should equal(@"Next");
        });
    });
    
    context(@"when the view appears", ^{
        it(@"should update the reference and date", ^{
            [controller viewWillAppear:YES];
            controller.referenceLabel.text should equal(@"John 1");
            controller.dateLabel.text should equal(SpecEnvironment.yesterday.readerFormat);
        });
        
        context(@"when the passage is available", ^{
            beforeEach(^{
                [CachedPassage passageWithReference:@"John 1" content:@"In the beginning..." date:[NSDate date]];
                [controller viewWillAppear:YES];
            });
            
            it(@"should present the content and hide the spinner/loading label/retry button", ^{
                controller.containerView.subviews.lastObject should equal(controller.contentWebView);
                controller.contentWebView.loadedHTMLString should contain(@"In the beginning...");
            });
            
            context(@"when the user taps the toggle button", ^{
                it(@"should toggle the reading state of the reading and update the button", ^{
                    controller.toggleReadStateButton.enabled should be_truthy();
                    
                    Reading *firstReading = dataSource.reading;
                    dataSource.reading.isRead.boolValue should_not be_truthy();
                    [controller.toggleReadStateButton imageForState:UIControlStateNormal] should equal([UIImage imageNamed:@"Unread.png"]);
                    
                    [controller.toggleReadStateButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    firstReading.isRead.boolValue should be_truthy();
                    
                    //Second reading is now visible
                    dataSource.reading.isRead.boolValue should_not be_truthy();
                    [controller.toggleReadStateButton imageForState:UIControlStateNormal] should equal([UIImage imageNamed:@"Unread.png"]);
                    
                    controller.referenceLabel.text should equal(@"John 2");
                    controller.dateLabel.text should equal(SpecEnvironment.today.readerFormat);
                    controller.containerView.subviews.lastObject should equal(controller.loadingView);
                    controller.toggleReadStateButton.enabled should_not be_truthy();
                    
                    [NSURLConnection provideSuccesfulResponse:@"On the third day..." forURL:dataSource.reading.passage.url];
                    controller.toggleReadStateButton.enabled should be_truthy();
                    controller.containerView.subviews.lastObject should equal(controller.contentWebView);
                    controller.contentWebView.loadedHTMLString should contain(@"On the third day...");
                    
                    [controller.toggleReadStateButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    
                    //third reading is now visible
                    controller.referenceLabel.text should equal(@"John 3");
                    controller.dateLabel.text should equal(SpecEnvironment.tomorrow.readerFormat);
                    controller.containerView.subviews.lastObject should equal(controller.loadingView);
                    [NSURLConnection provideSuccesfulResponse:@"..." forURL:dataSource.reading.passage.url];
                    controller.containerView.subviews.lastObject should equal(controller.contentWebView);
                    controller.contentWebView.loadedHTMLString should contain(@"...");
                    
                    [controller.toggleReadStateButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    
                    //no more readings are available
                    controller.containerView.subviews.lastObject should equal(controller.finishedReadingsView);                    
                    controller.toggleReadStateButton.enabled should_not be_truthy();
                });
            });
        });
    });
});

SPEC_END
