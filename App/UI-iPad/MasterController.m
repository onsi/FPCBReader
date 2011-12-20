#import "MasterController.h"
#import "ReadingCell.h"
#import "Reading.h"
#import "NavigationReadingViewController.h"
#import "SpecificReadingDataSource.h"
#import "Reader.h"
#import "DetailController.h"

@interface MasterController ()

@property (nonatomic, retain) NSArray *readings;

- (void)scrollToReading:(Reading *)reading;
- (void)refreshColors;

@end

@implementation MasterController

@synthesize
    readings = readings_, 
    detailController = detailController_,
    tableView = tableView_,
    fontSizeSlider = fontSizeSlider_,
    invert = invert_,
    topToolbar = topToolbar_,
    fontSizeImageView = fontSizeImageView_,
    brightnessImageView = brightnessImageView_;

+ (MasterController *)controller {
    MasterController *controller = [[[self alloc] initWithNibName:@"MasterController" bundle:nil] autorelease];
    controller.detailController = [DetailController controller];
    return controller;
}


#pragma mark - View lifecycle

- (void)dealloc {
    self.readings = nil;
    self.detailController = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.readings = [Reading readings];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    self.fontSizeSlider.value = reader.settings.fontSize.floatValue;
    [self.invert setOn:reader.settings.invert.boolValue];
    self.tableView.rowHeight = 60;
    
    int todaysIndex = [self.readings indexOfObject:[Reading todaysReading]];
    if (todaysIndex != NSNotFound) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:todaysIndex inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop 
                                      animated:NO];
        self.detailController.reading = [Reading todaysReading];
    }
    
    [self refreshColors];
}

- (IBAction)didUpdateFontSize {
    reader.settings.fontSize = [NSNumber numberWithFloat:self.fontSizeSlider.value];
    [reader.dataManager saveContext];
    [self.detailController refresh];
}

- (IBAction)didToggleInvert {
    reader.settings.invert = [NSNumber numberWithBool:self.invert.isOn];
    [reader.dataManager saveContext];
    [self.detailController refresh];
    [self refreshColors];
}

- (void)refreshColors {
    self.topToolbar.barStyle = reader.settings.invert.boolValue ? UIBarStyleDefault : UIBarStyleBlack;
    
    self.fontSizeImageView.image = reader.fontSizeImage;
    self.brightnessImageView.image = reader.brightnessImage;
    self.view.backgroundColor = reader.backgroundColor;
    self.tableView.backgroundColor = reader.backgroundColor;
    
    for (ReadingCell *cell in self.tableView.visibleCells) {
        [cell refresh];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:reader.settings.invert.boolValue ? UIStatusBarStyleDefault : UIStatusBarStyleBlackOpaque
                                                animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)didTapTodayButton {
    [self scrollToReading:[Reading todaysReading]];
}

- (IBAction)didTapUnreadButton {
    [self scrollToReading:[Reading nextUnreadReading]];
}

- (void)scrollToReading:(Reading *)reading {
    int index = [self.readings indexOfObject:reading];
    if (index != NSNotFound) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop 
                                      animated:YES];
        self.detailController.reading = reading;
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.readings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ReadingCell";
    
    ReadingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [ReadingCell cell];
    }
    cell.reading = [self.readings objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Reading *reading = [self.readings objectAtIndex:indexPath.row];
    self.detailController.reading = reading;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
