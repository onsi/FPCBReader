#import "AllReadingsTableViewController.h"
#import "ReadingCell.h"
#import "Reading.h"
#import "NavigationReadingViewController.h"
#import "SpecificReadingDataSource.h"
#import "Reader.h"

@interface AllReadingsTableViewController ()

@property (nonatomic, retain) NSArray *readings;
@property (nonatomic, assign) BOOL firstView;

@end

@implementation AllReadingsTableViewController

@synthesize readings = readings_, firstView = firstView_;

+ (AllReadingsTableViewController *)controller {
    return [[[self alloc] initWithNibName:@"AllReadingsTableViewController" bundle:nil] autorelease];
}

#pragma mark - View lifecycle

- (void)dealloc {
    self.readings = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.readings = [Reading readings];
    self.navigationController.navigationBarHidden = YES;
    self.firstView = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    self.tableView.backgroundColor = reader.backgroundColor;
    self.tableView.rowHeight = 60;
    for (ReadingCell *cell in self.tableView.visibleCells) {
        [cell refresh];
    }
    if (self.firstView) {
        int todaysIndex = [self.readings indexOfObject:[Reading todaysReading]];
        if (todaysIndex != NSNotFound) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:todaysIndex inSection:0]
                                  atScrollPosition:UITableViewScrollPositionTop 
                                          animated:NO];
        }
        self.firstView = NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Reading *reading = [self.readings objectAtIndex:indexPath.row];
    SpecificReadingDataSource *dataSource = [SpecificReadingDataSource dataSourceWithReading:reading];
    [self.navigationController pushViewController:[NavigationReadingViewController controllerWithDataSource:dataSource]
                                         animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
