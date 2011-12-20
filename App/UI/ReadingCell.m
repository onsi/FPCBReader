#import "ReadingCell.h"
#import "NSDate+FPCBReader.h"
#import "Reading.h"
#import "Reader.h"

@interface ReadingCell ()

- (void)refreshReadButton;

@end


@implementation ReadingCell

@synthesize
    readingLabel = readingLabel_,
    dateLabel = dateLabel_,
    toggleReadStateButton = toggleReadStateButton_,
    reading = reading_,
    todayImageView = todayImageView_;

+ (ReadingCell *)cell {
   return [[[NSBundle mainBundle] loadNibNamed:@"ReadingCell" owner:nil options:nil] lastObject];
}

- (void)setReading:(Reading *)reading {
    [reading_ removeObserver:self forKeyPath:@"isRead"];
    reading_ = reading;
    [reading_ addObserver:self
               forKeyPath:@"isRead"
                  options:0
                  context:nil];
    [self refresh];
}

- (void)dealloc {
    self.reading = nil;
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self refresh];
}

- (void)refresh {
    self.backgroundColor = reader.backgroundColor;
    self.dateLabel.textColor = reader.textColor;
    self.readingLabel.textColor = reader.textColor;
    
    self.dateLabel.text = self.reading.date.readerFormat;
    self.readingLabel.text = self.reading.reference;
    self.todayImageView.hidden = YES;
    if ([self.reading.date isEqualToDate:[[NSDate date] dateByRemovingTimeComponent]]) {
        self.todayImageView.hidden = NO;
        self.todayImageView.image = reader.todayImage;
        
    }
    [self refreshReadButton];
}

- (void)refreshReadButton {
    NSString *imageName;
    if (self.reading.isRead.boolValue) {
        imageName = @"Read.png";
    } else {
        imageName = @"Unread.png";        
    }
    [self.toggleReadStateButton setImage:[UIImage imageNamed:imageName] 
                                forState:UIControlStateNormal];
}

- (void)didTapToggleReadingButton {
    [self.reading toggleReadingState];
    [self refreshReadButton];
}


@end
