#import <UIKit/UIKit.h>

@class Reading;

@interface ReadingCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *readingLabel;
@property (nonatomic, assign) IBOutlet UILabel *dateLabel;
@property (nonatomic, assign) IBOutlet UIButton *toggleReadStateButton;
@property (nonatomic, assign) Reading *reading;

+ (ReadingCell *)cell;
- (IBAction)didTapToggleReadingButton;
- (void)refresh;

@end
