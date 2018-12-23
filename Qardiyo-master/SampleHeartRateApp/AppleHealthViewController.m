#import "AppleHealthViewController.h"
#import "AppleHealthCustomCell.h"
#import "Constants.h"

@interface AppleHealthViewController ()
@end

@implementation AppleHealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

/*-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        headerView.frame = CGRectMake(0, 0, 320, 50);
    }else{
        headerView.frame = CGRectMake(0, 0, 768, 50);
    }
    headerView.backgroundColor = [UIColor clearColor];
    
    NSString *titleHeader = [[sortedDB_Arr objectAtIndex:section] valueForKey:@"section"];
    NSString *avgBeat = [NSString stringWithFormat:@"Avg %@",[[sortedDB_Arr objectAtIndex:section] valueForKey:@"avgPulseSectionCount"]];
    
    UILabel *MonthHeaderTitle = [[UILabel alloc] init];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        MonthHeaderTitle.frame = CGRectMake(10, 10, 320, 30);
        MonthHeaderTitle.font = [UIFont boldSystemFontOfSize:15.0f];
    }else{
        MonthHeaderTitle.frame = CGRectMake(10, 10, 768, 30);
        MonthHeaderTitle.font = [UIFont boldSystemFontOfSize:17.0f];
    }
    MonthHeaderTitle.text = titleHeader;
    [MonthHeaderTitle setTextColor:[UIColor whiteColor]];
    MonthHeaderTitle.textAlignment = NSTextAlignmentLeft;
    MonthHeaderTitle.textColor = [UIColor colorWithRed:0/255.0 green:109/255.0 blue:157/255.0 alpha:1.0];
    [headerView addSubview:MonthHeaderTitle];
    
    UILabel *avgBeatHeaderTitle = [[UILabel alloc] init];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        avgBeatHeaderTitle.frame = CGRectMake(10, 10, 300, 30);
        avgBeatHeaderTitle.font = [UIFont boldSystemFontOfSize:15.0f];
    }else{
        avgBeatHeaderTitle.frame = CGRectMake(10, 10, 768-30, 30);
        avgBeatHeaderTitle.font = [UIFont boldSystemFontOfSize:17.0f];
    }
    avgBeatHeaderTitle.text = avgBeat;
    [avgBeatHeaderTitle setTextColor:[UIColor whiteColor]];
    avgBeatHeaderTitle.textAlignment = NSTextAlignmentRight;
    avgBeatHeaderTitle.textColor = [UIColor colorWithRed:0/255.0 green:109/255.0 blue:157/255.0 alpha:1.0];
    [headerView addSubview:avgBeatHeaderTitle];
    
    return headerView;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat Row = 0;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        Row = 60;
    }else{
        Row = 60;
    }
    return Row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myIdentifire = @"AppleHealthCustomCell";
    AppleHealthCustomCell *appleHealthCustomCell = (AppleHealthCustomCell *)[tableView dequeueReusableCellWithIdentifier:myIdentifire];
    if (appleHealthCustomCell == nil){
        NSArray *nib;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            nib = [[NSBundle mainBundle] loadNibNamed:@"AppleHealthCustomCell_iPhone" owner:self options:nil];
        }else{
            nib = [[NSBundle mainBundle] loadNibNamed:@"AppleHealthCustomCell_iPad" owner:self options:nil];
        }
        appleHealthCustomCell = (AppleHealthCustomCell *)[nib objectAtIndex:0];
    }
    
    return appleHealthCustomCell;
}

@end
