#import <Cedar-iPhone/SpecHelper.h>
using namespace Cedar::Matchers;

#import "ReadingViewController.h"
#import "TodaysReadingDataSource.h"
#import "Reading.h"
#import "SpecEnvironment.h"
#import "CachedPassage+Spec.h"
#import "UIWebView+Spec.h"
#import "NSURLConnection+Spec.h"
#import "UIPageViewController+Spec.h"

SPEC_BEGIN(Todays_ReadingViewControllerSpec)

describe(@"ReadingViewController", ^{
    __block ReadingViewController *controller;
    __block TodaysReadingDataSource *dataSource;
    __block UIPageViewController *pageViewController;
    
    beforeEach(^{
		dataSource = [TodaysReadingDataSource dataSource];
        controller = [ReadingViewController controllerWithDataSource:dataSource];
        pageViewController = [UIPageViewController pageViewControllerWithController:controller];
        controller.view should_not be_nil();
    });
    
    describe(@"tabBarItem", ^{
        it(@"should have the correct tab bar item", ^{
            controller.tabBarItem.title should equal(@"Today");
        });
    });
    
    context(@"when the view appears", ^{
        it(@"should update the reference and date", ^{
            [controller viewWillAppear:YES];
            controller.referenceLabel.text should equal(@"John 2");
            controller.dateLabel.text should equal(SpecEnvironment.today.readerFormat);
        });
        
        context(@"when the passage is available", ^{
            beforeEach(^{
                [CachedPassage passageWithReference:@"John 2" content:@"On the third day..." date:[NSDate date]];
                [controller viewWillAppear:YES];
            });
            
            it(@"should present the content and hide the spinner/loading label/retry button", ^{
                controller.containerView.subviews.lastObject should equal(controller.contentWebView);
                controller.contentWebView.hidden should be_truthy();
                controller.contentWebView.loadedHTMLString should contain(@"On the third day...");
                [controller.contentWebView finishLoad];
                controller.contentWebView.hidden should_not be_truthy();
            });
            
            context(@"when the user taps the toggle button", ^{
                it(@"should toggle the reading state of the reading and update the button", ^{
                    controller.toggleReadStateButton.enabled should be_truthy();
                    
                    dataSource.reading.isRead.boolValue should_not be_truthy();
                    [controller.toggleReadStateButton imageForState:UIControlStateNormal] should equal([UIImage imageNamed:@"Unread.png"]);
                    [controller.toggleReadStateButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    dataSource.reading.isRead.boolValue should be_truthy();
                    [controller.toggleReadStateButton imageForState:UIControlStateNormal] should equal([UIImage imageNamed:@"Read.png"]);     
                });
            });
        });
        
        context(@"when the reading does not exist", ^{
            it(@"should show the finishedReadingsView", ^{
                [reader.dataManager.managedObjectContext deleteObject:dataSource.reading];
                [controller viewWillAppear:YES];
                
                controller.containerView.subviews.lastObject should equal(controller.finishedReadingsView);                    
                controller.toggleReadStateButton.enabled should_not be_truthy();
            });
        });
        
        context(@"when the passage needs to be downloaded", ^{
            beforeEach(^{
                [controller viewWillAppear:YES];
                NSURLConnection.connections.count should equal(1);
            });
            
            it(@"should present the loading view", ^{
                controller.containerView.subviews.lastObject should equal(controller.loadingView);
                controller.toggleReadStateButton.enabled should_not be_truthy();
            });
            
            context(@"when the passage arrives", ^{
                beforeEach(^{
                    [NSURLConnection provideSuccesfulResponse:@"On the third day..." forURL:dataSource.reading.passage.url];
                    NSURLConnection.connections.count should equal(0);
                });
                     
                it(@"should update the content view with the downloaded content and hide the loading paraphenalia", ^{
                    controller.toggleReadStateButton.enabled should be_truthy();
                    controller.containerView.subviews.lastObject should equal(controller.contentWebView);
                    controller.contentWebView.loadedHTMLString should contain(@"On the third day...");
                });
            });
            
            context(@"if the passage fails to arrive", ^{
                beforeEach(^{
                    [NSURLConnection provideFailedResponseForURL:dataSource.reading.passage.url];
                    NSURLConnection.connections.count should equal(0);
                });
                
                it(@"should notify the user of the error in the loading paraphenalia and give them a button to tap", ^{
                    controller.toggleReadStateButton.enabled should_not be_truthy();
                    controller.containerView.subviews.lastObject should equal(controller.retryView);
                });
                
                context(@"when the user taps the reload button", ^{
                    beforeEach(^{
                        [controller.retryButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    });
                    
                    it(@"should show the loading spinner again and attempt to fetch the download again", ^{
                        controller.toggleReadStateButton.enabled should_not be_truthy();
                        controller.containerView.subviews.lastObject should equal(controller.loadingView);
                        NSURLConnection.connections.count should equal(1);
                        [[NSURLConnection.connections.lastObject request] URL] should equal(dataSource.reading.passage.url);
                    });
                });
                
                context(@"when the user navigates back to the tab", ^{
                    beforeEach(^{
                        [controller viewWillAppear:YES];                        
                    });
                    
                    it(@"should show the loading spinner again and attempt to fetch the download again", ^{
                        controller.toggleReadStateButton.enabled should_not be_truthy();
                        controller.containerView.subviews.lastObject should equal(controller.loadingView);
                        NSURLConnection.connections.count should equal(1);
                        [[NSURLConnection.connections.lastObject request] URL] should equal(dataSource.reading.passage.url);
                    });
                });
            });
        });
    });
});

SPEC_END
