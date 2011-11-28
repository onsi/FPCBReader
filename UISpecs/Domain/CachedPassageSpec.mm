#import <Cedar-iPhone/SpecHelper.h>
using namespace Cedar::Matchers;

#import "CachedPassage.h"
#import "Reader.h"

SPEC_BEGIN(CachedPassageSpec)

describe(@"CachedPassage", ^{
    describe(@"creating a new cached passage", ^{
        context(@"when the reference does not exist yet", ^{
            it(@"should store off the reference and content and save off the current date", ^{
                CachedPassage *cachedPassage = [CachedPassage passageWithReference:@"John 1:1"
                                                                           content:@"In the beginning..."];
                cachedPassage.reference should equal(@"John 1:1");
                cachedPassage.content should equal(@"In the beginning...");
                [[NSDate date] timeIntervalSinceDate:cachedPassage.date] should be_less_than(1);
            });
        });
        
        context(@"when the reference already exists", ^{
            beforeEach(^{
                CachedPassage *passage = [CachedPassage passageWithReference:@"John 1:1"
                                                                     content:@"In the..."];
                passage.date = [NSDate dateWithTimeIntervalSinceNow:-1000];
                [passage save];
            });
            
            it(@"should update the existing passage", ^{
                [CachedPassage passageWithReference:@"John 1:1"
                                            content:@"In the beginning..."];
                
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CachedPassage"];
                [request setPredicate:[NSPredicate predicateWithFormat:@"reference = 'John 1:1'"]];
                NSArray *results = [reader.dataManager.managedObjectContext executeFetchRequest:request error:NULL];
                
                results.count should equal(1);
                [results.lastObject content] should equal(@"In the beginning...");
                [[NSDate date] timeIntervalSinceDate:[results.lastObject date]] should be_less_than(1);
            });
        });
    });
    
    describe(@"getting the oldest cached passage", ^{
        __block NSDate *date;
        beforeEach(^{
            [CachedPassage passageWithReference:@"John 1:1"
                                        content:@"In the beginning..."];
            
            CachedPassage *cachedPassage = [CachedPassage passageWithReference:@"Luke 1:1"
                                                                       content:@"..."];            
            date = [NSDate dateWithTimeIntervalSinceNow:-10];
            cachedPassage.date = date;
            [cachedPassage save];            
        });
        
        it(@"should return the cached passage with the oldest date", ^{
            [CachedPassage oldestPassage].reference should equal(@"Luke 1:1");
            [CachedPassage oldestPassage].date should equal(date);
        });
    });
    
    describe(@"getting a passage with a given reference", ^{
        beforeEach(^{
            CachedPassage *passage = [CachedPassage passageWithReference:@"John 1:1"
                                                                 content:@"In the beginning..."];
            passage.date = [NSDate dateWithTimeIntervalSinceNow:-1000];
            [passage save];
        });

        context(@"when the passage already exists", ^{
            it(@"should return the passage, bump the passages date, and save it", ^{
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CachedPassage"];
                [request setPredicate:[NSPredicate predicateWithFormat:@"reference = 'John 1:1'"]];
                NSArray *results = [reader.dataManager.managedObjectContext executeFetchRequest:request error:NULL];
                CachedPassage *passage = results.lastObject;
                
                [CachedPassage passageForReference:@"John 1:1"] should equal(passage);
                [[NSDate date] timeIntervalSinceDate:passage.date] should be_less_than(1);
                passage.reference should equal(@"John 1:1");
                passage.content should equal(@"In the beginning...");
            });
        });
        
        context(@"when the passage does not exist", ^{
            it(@"should return nil", ^{
                [CachedPassage passageForReference:@"Luke 1:1"] should be_nil();
            });
        });
    });
});

SPEC_END
