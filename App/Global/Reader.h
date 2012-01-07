#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "Settings.h"

@interface Reader : NSObject

@property (nonatomic, retain, readonly) DataManager *dataManager;
@property (nonatomic, retain, readonly) Settings *settings;

- (void)performSetUp;
- (NSString *)htmlFormatContent:(NSString *)content;
- (NSString *)preview;
- (NSString *)javascriptToUpdateStyling;

- (UIColor *)backgroundColor;
- (UIColor *)textColor;
- (UIImage *)fontSizeImage;
- (UIImage *)brightnessImage;
- (UIImage *)topGradient;
- (UIImage *)bottomGradient;
- (UIImage *)todayImage;

@end

extern Reader *reader;