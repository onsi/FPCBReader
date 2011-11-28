#import <Cedar-iPhone/SpecHelper.h>
using namespace Cedar::Matchers;

#import "Passages.h"
#import "Reader.h"

@interface FakeDelegate : NSObject <PassageDelegate>

@property (nonatomic, assign) BOOL notified;

@end

@implementation FakeDelegate

@synthesize notified;

- (void)didDownloadPassageForReference:(NSString *)reference {
    self.notified = YES;
}

@end

SPEC_BEGIN(PassagesSpec)

describe(@"Passages", ^{
    __block Passages *passages;

    beforeEach(^{
		passages = reader.passages;
    });
    
    describe(@"requesting a passage for a reference", ^{
        context(@"when the passage is already present (cached)", ^{
            beforeEach(^{
                
            });
            
            it(@"should return the cached passage", ^{
                
            });
            
            it(@"should update the cached passage's date to reflect the fact that it has been touched", ^{
                
            });
            
            it(@"should not keep track of the delegate and/or notify it if the cached passage is (somehow) downloaded", ^{
                
            });
        });
    });
});

SPEC_END
