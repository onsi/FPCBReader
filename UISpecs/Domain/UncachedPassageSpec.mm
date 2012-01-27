#import <Cedar-iPhone/SpecHelper.h>
using namespace Cedar::Matchers;

#import "UncachedPassage.h"
#import "Reader.h"
#import "NotificationObserver.h"
#import "PivotalSpecHelperKit.h"

SPEC_BEGIN(UncachedPassageSpec)

describe(@"UncachedPassage", ^{
    describe(@"getting a passage", ^{
        __block NSURL *url;
        
        beforeEach(^{
            NSString *urlString = @"http://www.esvapi.org/v2/rest/passageQuery?key=SPEC_KEY&include-footnotes=false&include-audio-link=false&passage=John 1:1";
            url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        });
            
        it(@"should return the passage with nil content.", ^{
            UncachedPassage *passage = [UncachedPassage passageForReference:@"John 1:1"];
            passage.reference should equal(@"John 1:1");
            passage.content should be_nil();
        });
            
        context(@"when the passage gets downloaded", ^{
            it(@"should post a notification and update the passage's date", ^{
                NotificationObserver *observer = [NotificationObserver observerForNotificationNamed:@"didDownloadPassage"];
                UncachedPassage *passage = [UncachedPassage passageForReference:@"John 1:1"];
                
                [NSURLConnection provideSuccesfulResponse:@"In the beginning..."
                                                   forURL:url];
                
                passage.content should equal(@"In the beginning...");
                observer.notification.object should equal(passage);
            });
        });
            
        context(@"when the download fails", ^{
            it(@"should post a notification and stay nil", ^{
                NotificationObserver *observer = [NotificationObserver observerForNotificationNamed:@"downloadDidFail"];
                
                UncachedPassage *passage = [UncachedPassage passageForReference:@"John 1:1"];
                [NSURLConnection provideFailedResponseForURL:url];
                
                passage.content should be_nil;
                observer.notification.object should equal(passage);
            });
        });
        
        context(@"when the download has failed at an earlier time", ^{                
            it(@"should reschedule the download", ^{
                NotificationObserver *observer = [NotificationObserver observerForNotificationNamed:@"didDownloadPassage"];
                UncachedPassage *passage = [UncachedPassage passageForReference:@"John 1:1"];
                
                [NSURLConnection provideFailedResponseForURL:url];
                
                passage = [UncachedPassage passageForReference:@"John 1:1"];
                
                [NSURLConnection provideSuccesfulResponse:@"In the beginning..."
                                                   forURL:url];
                
                passage.content should equal(@"In the beginning...");
                observer.notification.object should equal(passage);
            });
        });
            
        context(@"when the passage is requested twice", ^{
            it(@"should not initiate a new download", ^{
                NotificationObserver *observer = [NotificationObserver observerForNotificationNamed:@"didDownloadPassage"];
                [UncachedPassage passageForReference:@"John 1:1"];
                [UncachedPassage passageForReference:@"John 1:1"];
                
                [NSURLConnection provideSuccesfulResponse:@"In the beginning..."
                                                   forURL:url];
                
                observer.notificationCount should equal(1);
            });
        });
    });
});

SPEC_END
