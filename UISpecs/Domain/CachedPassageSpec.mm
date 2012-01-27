#import <Cedar-iPhone/SpecHelper.h>
using namespace Cedar::Matchers;

#import "CachedPassage+Spec.h"
#import "Reader.h"
#import "NotificationObserver.h"
#import "PivotalSpecHelperKit.h"

SPEC_BEGIN(CachedPassageSpec)

describe(@"CachedPassage", ^{
    describe(@"clearAllCachedPassages", ^{
        beforeEach(^{
            [CachedPassage passageWithReference:@"John 1:1"
                                        content:@"In the beginning..."
                                           date:[NSDate dateWithTimeIntervalSinceNow:-1000]];
        });
        
        it(@"it should delete all the passages", ^{
            CachedPassage *passage = [CachedPassage passageForReference:@"John 1:1"];
            passage.reference should equal(@"John 1:1");
            passage.content should equal(@"In the beginning...");
            
            [CachedPassage clearAllCachedPassages];
            
            passage = [CachedPassage passageForReference:@"John 1:1"];
            passage.reference should equal(@"John 1:1");
            passage.content should be_nil();
        });
    });
    
    describe(@"getting a passage", ^{
        context(@"when the passage is already cached", ^{
            beforeEach(^{
                [CachedPassage passageWithReference:@"John 1:1"
                                            content:@"In the beginning..."
                                               date:[NSDate dateWithTimeIntervalSinceNow:-1000]];
            });
            
            it(@"should return the passage and update it's date", ^{
                CachedPassage *passage = [CachedPassage passageForReference:@"John 1:1"];
                passage.reference should equal(@"John 1:1");
                passage.content should equal(@"In the beginning...");
                [[NSDate date] timeIntervalSinceDate:passage.date] should be_less_than(1);
            });
        });
        
        context(@"when the passage has not been cached yet", ^{
            __block NSURL *url;
            
            beforeEach(^{
                NSString *urlString = @"http://www.esvapi.org/v2/rest/passageQuery?key=SPEC_KEY&include-footnotes=false&include-audio-link=false&passage=John 1:1";
                url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                for (int i = 0 ; i < 29 ; i++) {
                    [CachedPassage passageWithReference:[NSString stringWithFormat:@"Passage %d", i]
                                                content:[NSString stringWithFormat:@"Content %d", i]
                                                   date:[NSDate dateWithTimeIntervalSinceNow:10 * (i)*(i - 30)]];
                }
            });
            context(@"and there are 30 passages in the cache", ^{                
                beforeEach(^{
                    int i = 30;
                    [CachedPassage passageWithReference:[NSString stringWithFormat:@"Passage %d", i]
                                                content:[NSString stringWithFormat:@"Content %d", i]
                                                   date:[NSDate dateWithTimeIntervalSinceNow:10 * (i)*(i - 30)]];
                });
                
                it(@"should delete the oldest passage", ^{
                    [CachedPassage passageForReference:@"John 1:1"];
                    
                    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CachedPassage"];
                    [request setPredicate:[NSPredicate predicateWithFormat:@"reference = 'Passage 15'"]];
                    NSArray *results = [reader.dataManager.managedObjectContext executeFetchRequest:request error:NULL];
                    results should be_empty();

                    request = [NSFetchRequest fetchRequestWithEntityName:@"CachedPassage"];
                    results = [reader.dataManager.managedObjectContext executeFetchRequest:request error:NULL];
                    results.count should equal(30);
                });
            });
            
            context(@"and there are fewer than 30 passages in the cache", ^{
                it(@"should not delete the oldest passage", ^{
                    [CachedPassage passageForReference:@"John 1:1"];
                    
                    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CachedPassage"];
                    [request setPredicate:[NSPredicate predicateWithFormat:@"reference = 'Passage 15'"]];
                    NSArray *results = [reader.dataManager.managedObjectContext executeFetchRequest:request error:NULL];
                    results should_not be_empty();
                    
                    request = [NSFetchRequest fetchRequestWithEntityName:@"CachedPassage"];
                    results = [reader.dataManager.managedObjectContext executeFetchRequest:request error:NULL];
                    results.count should equal(30);
                });
            });
            
            
            it(@"should return the passage with nil content.", ^{
                CachedPassage *passage = [CachedPassage passageForReference:@"John 1:1"];
                passage.reference should equal(@"John 1:1");
                passage.content should be_nil();
                [[NSDate date] timeIntervalSinceDate:passage.date] should be_less_than(1);
            });
            
            context(@"when the passage gets downloaded", ^{
                it(@"should post a notification and update the passage's date", ^{
                    NotificationObserver *observer = [NotificationObserver observerForNotificationNamed:@"didDownloadPassage"];
                    CachedPassage *passage = [CachedPassage passageForReference:@"John 1:1"];
                    passage.date = [NSDate dateWithTimeIntervalSinceNow:-1000];
                    
                    [NSURLConnection provideSuccesfulResponse:@"In the beginning..."
                                                       forURL:url];
                    
                    passage.content should equal(@"In the beginning...");
                    observer.notification.object should equal(passage);
                    [[NSDate date] timeIntervalSinceDate:passage.date] should be_less_than(1);
                });
            });
            
            context(@"when the download fails", ^{
                it(@"should post a notification and stay nil", ^{
                    NotificationObserver *observer = [NotificationObserver observerForNotificationNamed:@"downloadDidFail"];

                    CachedPassage *passage = [CachedPassage passageForReference:@"John 1:1"];
                    [NSURLConnection provideFailedResponseForURL:url];
                    
                    passage.content should be_nil;
                    observer.notification.object should equal(passage);
                });
            });
            
            context(@"when the download has failed at an earlier time", ^{                
                it(@"should reschedule the download", ^{
                    NotificationObserver *observer = [NotificationObserver observerForNotificationNamed:@"didDownloadPassage"];
                    CachedPassage *passage = [CachedPassage passageForReference:@"John 1:1"];

                    [NSURLConnection provideFailedResponseForURL:url];
                    
                    passage = [CachedPassage passageForReference:@"John 1:1"];

                    [NSURLConnection provideSuccesfulResponse:@"In the beginning..."
                                                       forURL:url];
                    
                    passage.content should equal(@"In the beginning...");
                    observer.notification.object should equal(passage);
                    [[NSDate date] timeIntervalSinceDate:passage.date] should be_less_than(1);
                });
            });
            
            context(@"when the passage is requested twice", ^{
                it(@"should not initiate a new download", ^{
                    NotificationObserver *observer = [NotificationObserver observerForNotificationNamed:@"didDownloadPassage"];
                    CachedPassage *passage = [CachedPassage passageForReference:@"John 1:1"];
                    [CachedPassage passageForReference:@"John 1:1"];
                    
                    [NSURLConnection provideSuccesfulResponse:@"In the beginning..."
                                                       forURL:url];
                    
                    observer.notificationCount should equal(1);
                    observer.notification.object should equal(passage);
                });
            });
            
            context(@"if the passage is deleted before it is downloaded", ^{
                it(@"should cancel the download", ^{
                    NotificationObserver *observer = [NotificationObserver observerForNotificationNamed:@"didDownloadPassage"];
                    CachedPassage *passage = [CachedPassage passageForReference:@"John 1:1"];
                    [reader.dataManager.managedObjectContext deleteObject:passage];
                    [reader.dataManager saveContext];
                    
                    [NSURLConnection provideSuccesfulResponse:@"In the beginning..."
                                                       forURL:url];
                    
                    observer.notificationCount should equal(0);
                    observer.notification.object should be_nil();
                    
                    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CachedPassage"];
                    [request setPredicate:[NSPredicate predicateWithFormat:@"reference = 'John 1:1'"]];
                    NSArray *results = [reader.dataManager.managedObjectContext executeFetchRequest:request error:NULL];
                    results should be_empty();
                });
            });
        });
    });
});

SPEC_END
