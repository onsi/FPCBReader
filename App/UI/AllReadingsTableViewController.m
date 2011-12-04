#import "AllReadingsTableViewController.h"
#import "ReadingCell.h"
#import "Reading.h"
#import "NavigationReadingViewController.h"
#import "SpecificReadingDataSource.h"

@interface AllReadingsTableViewController ()

@property (nonatomic, retain) NSArray *readings;

@end

@implementation AllReadingsTableViewController

@synthesize readings = readings_;

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
    //perhaps scroll to next unread passage?
}

- (void)viewWillAppear:(BOOL)animated {
    for (ReadingCell *cell in self.tableView.visibleCells) {
        [cell refresh];
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
