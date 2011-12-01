@class Reading;

@protocol ReadingDataSource <NSObject>

- (Reading *)reading;
- (NSString *)tabItemTitle;

@end