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
    reading = reading_;

+ (ReadingCell *)cell {
   return [[[NSBundle mainBundle] loadNibNamed:@"ReadingCell" owner:nil options:nil] lastObject];
}

- (void)setReading:(Reading *)reading {
    reading_ = reading;
    [self refresh];
}

- (void)refresh {
    self.backgroundColor = reader.backgroundColor;
    self.dateLabel.textColor = reader.textColor;
    self.readingLabel.textColor = reader.textColor;
    
    self.dateLabel.text = self.reading.date.readerFormat;
    self.readingLabel.text = self.reading.reference;
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
