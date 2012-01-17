#import <Cedar-iPhone/SpecHelper.h>
using namespace Cedar::Matchers;

#import "ReadingViewController.h"
#import "NextUnreadReadingDataSource.h"
#import "Reading.h"
#import "SpecEnvironment.h"
#import "UIWebView+Spec.h"
#import "NSURLConnection+Spec.h"
#import "UIPageViewController+Spec.h"
#import "Passage.h"

SPEC_BEGIN(NextUnread_ReadingViewControllerSpec)

describe(@"ReadingViewController", ^{
    __block ReadingViewController *controller;
    __block NextUnreadReadingDataSource *dataSource;
    __block UIPageViewController *pageViewController;
    
    beforeEach(^{
		dataSource = [NextUnreadReadingDataSource dataSource];
        controller = [ReadingViewController controllerWithDataSource:dataSource];
        pageViewController = [UIPageViewController pageViewControllerWithController:controller];
        controller.view should_not be_nil();
        pageViewController.viewControllers.lastObject should equal(controller);
    });
    
    context(@"when the view appears", ^{
        it(@"should update the reference and date", ^{
            [controller viewWillAppear:YES];
            controller.referenceLabel.text should equal(@"John 1");
            controller.dateLabel.text should equal(SpecEnvironment.yesterday.readerFormat);
        });
        
        context(@"when the passage is available", ^{
            __block NSString *passageContent;
            beforeEach(^{
                [controller viewWillAppear:YES];
                [NSURLConnection provideSuccesfulResponse:@"In the beginning..."
                                                   forURL:dataSource.reading.passage.url];
                
            });
                   
            it(@"should present the content and hide the spinner/loading label/retry button", ^{
                controller.containerView.subviews.lastObject should equal(controller.contentWebView);
                controller.contentWebView.hidden should be_truthy();
                controller.contentWebView.loadedHTMLString should contain(@"In the beginning...");
                [controller.contentWebView finishLoad];
                controller.contentWebView.hidden should_not be_truthy();
            });
            
            sharedExamplesFor(@"displaying a passage", ^(NSDictionary *context) {
                it(@"should display the passage", ^{
                    controller.containerView.subviews.lastObject should equal(controller.contentWebView);
                    controller.contentWebView.hidden should be_truthy();
                    controller.contentWebView.loadedHTMLString should contain(passageContent);
                    [controller.contentWebView finishLoad];
                    controller.contentWebView.hidden should_not be_truthy();
                });
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
                    pageViewController.viewControllers.lastObject should_not equal(controller);
                    pageViewController.viewControllers.lastObject should be_instance_of([ReadingViewController class]);
                    controller = pageViewController.viewControllers.lastObject;
                    [controller viewWillAppear:NO];
                    
                    dataSource.reading.isRead.boolValue should_not be_truthy();
                    [controller.toggleReadStateButton imageForState:UIControlStateNormal] should equal([UIImage imageNamed:@"Unread.png"]);
                    
                    controller.referenceLabel.text should equal(@"John 2");
                    controller.dateLabel.text should equal(SpecEnvironment.today.readerFormat);
                    controller.containerView.subviews.lastObject should equal(controller.loadingView);
                    controller.toggleReadStateButton.enabled should_not be_truthy();
                    
                    
                    
                    [NSURLConnection provideSuccesfulResponse:@"On the third day..." forURL:dataSource.reading.passage.url];
                    controller.toggleReadStateButton.enabled should be_truthy();
                    controller.containerView.subviews.lastObject should equal(controller.contentWebView);
                    controller.contentWebView.hidden should be_truthy();
                    controller.contentWebView.loadedHTMLString should contain(@"On the third day...");
                    [controller.contentWebView finishLoad];
                    controller.contentWebView.hidden should_not be_truthy();
                    
                    [controller.toggleReadStateButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    
                    //third reading is now visible
                    pageViewController.viewControllers.lastObject should_not equal(controller);
                    pageViewController.viewControllers.lastObject should be_instance_of([ReadingViewController class]);
                    controller = pageViewController.viewControllers.lastObject;
                    [controller viewWillAppear:NO];

                    controller.referenceLabel.text should equal(@"John 3");
                    controller.dateLabel.text should equal(SpecEnvironment.tomorrow.readerFormat);
                    controller.containerView.subviews.lastObject should equal(controller.loadingView);
                    [NSURLConnection provideSuccesfulResponse:@"..." forURL:dataSource.reading.passage.url];
                    controller.containerView.subviews.lastObject should equal(controller.contentWebView);
                    controller.contentWebView.hidden should be_truthy();
                    controller.contentWebView.loadedHTMLString should contain(@"...");
                    [controller.contentWebView finishLoad];
                    controller.contentWebView.hidden should_not be_truthy();
                    
                    [controller.toggleReadStateButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    
                    //no more readings are available
                    pageViewController.viewControllers.lastObject should_not equal(controller);
                    pageViewController.viewControllers.lastObject should be_instance_of([ReadingViewController class]);
                    controller = pageViewController.viewControllers.lastObject;
                    [controller viewWillAppear:NO];

                    controller.containerView.subviews.lastObject should equal(controller.finishedReadingsView);                    
                    controller.toggleReadStateButton.enabled should_not be_truthy();
                });
            });
        });
    });
});

SPEC_END
