#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "DatabaseManager.h"
#import "AdMobViewController.h"
#import "Constants.h"

@interface HistoryViewController ()
@end

@implementation HistoryViewController

@synthesize tbl;
@synthesize sortedDB_Arr;
@synthesize barChart;
@synthesize barChartValue_Arr, barChartValueColor_Arr;
@synthesize avgPulseLine;
@synthesize avgPulseTxtLbl, avgPulseValueLbl;
@synthesize lbl_10Mesurment,lbl_avg;

- (void)viewDidLoad
{
    self.title = NSLocalizedStringFromTableInBundle(@"secondpagetitile", @"Localizable", [AppDelegate GetLocalizebundle], @"");
    
    lbl_10Mesurment.text = NSLocalizedStringFromTableInBundle(@"LAST 10 MEASUREMENT", @"Localizable", [AppDelegate GetLocalizebundle], @"");
    lbl_avg.text = NSLocalizedStringFromTableInBundle(@"AVG", @"Localizable", [AppDelegate GetLocalizebundle], @"");
    
  
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    [d setValue:@"yes" forKey:@"yes"];
    [d synchronize];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    DBManager = [[DatabaseManager alloc] init];
  [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    barChartValue_Arr = [[NSMutableArray alloc] init];
    barChartValueColor_Arr = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isfullPackPurchased"])
    {
//        [admobView setHidden:TRUE];
//        [admobView removeFromSuperview];
        admobView.hidden=true;
    }
    else
    {
        adMobViewController=[[AdMobViewController alloc] init];
        [admobView addSubview:adMobViewController.view];
        [self addChildViewController:adMobViewController];
    }

    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    [d setValue:@"yes" forKey:@"automaticLightON"];
    [d synchronize];

   
    id<GAITracker> trackerA = [[GAI sharedInstance] defaultTracker];
    [trackerA set:kGAIScreenName value:@"/HistoryViewController"];
    [trackerA send:[[GAIDictionaryBuilder createAppView] build]];
    
    [self adjustAdBannerPosition:YES];
    
    [sortedDB_Arr removeAllObjects];
    
    [barChartValue_Arr removeAllObjects];
    [barChartValueColor_Arr removeAllObjects];
    
    [self getDBMethod];
    [super viewWillAppear:animated];
}

- (BOOL)isDeviceAniPhone4{
    BOOL isiPhone5 = CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 960));
    return isiPhone5;
}

-(void)checkInApp{
    
    if ([AppDelegate isAppPurchased]) {
        
        //self->infoTableView.frame = UnLockFrame;
        [admobView removeFromSuperview];
    }
    else
    {
        //self->infoTableView.frame = LockFrame;
    }
    
    [self setadmobFrame];
}
-(void)setadmobFrame{
    
    [admobView setBackgroundColor:[UIColor clearColor]];
    
    if (Is_Iphone4 || Is_Iphone5) {
        admobView.frame = CGRectMake(0, admobView.frame.origin.y, 320, 50);
    }
    else if (Is_Iphone6){
        admobView.frame = CGRectMake(28,admobView.frame.origin.y, 320, 50);
        
    }
    else if (Is_Iphone6Plus){
        admobView.frame = CGRectMake(47, admobView.frame.origin.y, 320, 50);
        
    }
    else if (Is_Ipad){
        admobView.frame = CGRectMake(20, admobView.frame.origin.y, 728, 90);
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    }


- (void)adjustAdBannerPosition:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isfullPackPurchased"])
    {
        [admobView setHidden:TRUE];
        [admobView removeFromSuperview];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            [tbl setFrame:CGRectMake(0, 482, 768, 400+90)];
        }
        else
        {
            if([appDelegate isDeviceAniPhone4])
            {
                 [tbl setFrame:CGRectMake(0.0, 235.0, 320.0, 239-25)];
                //5

            }
            else
            {
                [tbl setFrame:CGRectMake(0.0, 235.0, 320.0, 283)];
               
            }
        }
    }
    else
    {
        [admobView setHidden:FALSE];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            admobView.frame = CGRectMake(20.0, 1024 - 90-50, 728, admobView.frame.size.height);
            [tbl setFrame:CGRectMake(0, 482, 768, 400)];
        }
        else
        {
            if([appDelegate isDeviceAniPhone4]){
                //4s
                [tbl setFrame:CGRectMake(0.0, 235.0, 320.0, 239-50-25)];
                admobView.frame = CGRectMake(0.0, 480-50-50, 320, admobView.frame.size.height);
            }
            else{

                
                //iphone 5
                [tbl setFrame:CGRectMake(0.0, 235.0, 320.0, 239)];
                admobView.frame = CGRectMake(0.0, 470.0+50-50, 320, admobView.frame.size.height);
                
            }
        }
    }
}
-(void)getDBMethod{
    sortedDB_Arr = [[NSMutableArray alloc] init];
    NSMutableArray *getAllDB_Arr = [DBManager getAllDataUsingQuery:@"SELECT * FROM HistoryData"];

    if (getAllDB_Arr.count > 0) {
        
        NSMutableArray *section_Arr = [[NSMutableArray alloc] init];
        
        NSMutableArray *generateNew_Arr = [[NSMutableArray alloc] init];
        
        NSDateFormatter* myFormatter = [[NSDateFormatter alloc] init];
        [myFormatter setDateFormat:@"dd/MM/yyyy HH:mm a"];
        
        NSDateFormatter* sectionFormatter = [[NSDateFormatter alloc] init];
        [sectionFormatter setDateFormat:@"MMM yyyy"];
        
        for (int i = 0; i < getAllDB_Arr.count; i++) {
            NSMutableDictionary *tempDict = [getAllDB_Arr objectAtIndex:i];
            NSDate *date = [myFormatter dateFromString:[tempDict valueForKey:@"date"]];
            NSString *dateString = [sectionFormatter stringFromDate:date];
            [tempDict setValue:dateString forKey:@"section_date"];
            [generateNew_Arr addObject:tempDict];
        }
//        NSLog(@"generateNew_Arr %@",generateNew_Arr);
        for (int i = 0; i < getAllDB_Arr.count; i++) {
            [section_Arr addObject:[[getAllDB_Arr objectAtIndex:i] valueForKey:@"section_date"]];
        }
//        NSLog(@"section %@",section_Arr);
        
        NSArray *SecDateArr = (NSMutableArray *)[NSOrderedSet orderedSetWithArray:section_Arr];
        if (SecDateArr.count > 0) {
            sortedDB_Arr = [self SortDateArr:generateNew_Arr SectionData:SecDateArr];
//            NSLog(@"sortedDB_Arr %@",sortedDB_Arr);
        }
        
        int avgAllPulse = 0;
        int totalAllPulse = 0;
        
        for (int k = 0; k < sortedDB_Arr.count; k++) {
            NSMutableArray *tempBarValue_arr = [[sortedDB_Arr objectAtIndex:k] valueForKey:@"setion_data"];
            for (int h = 0; h < tempBarValue_arr.count; h++) {
                [barChartValue_Arr addObject:[[tempBarValue_arr objectAtIndex:h] valueForKey:@"heartbeat"]];
                [barChartValueColor_Arr addObject:@"CC0000"];
                
                totalAllPulse = totalAllPulse + [[[tempBarValue_arr objectAtIndex:h] valueForKey:@"heartbeat"] integerValue];
            }
        }
        
//        NSLog(@"barChartValue_Arr %@ - %@",barChartValue_Arr, barChartValueColor_Arr);
        
        avgAllPulse = totalAllPulse/barChartValue_Arr.count;
//        NSLog(@"avgAllPulse - %d",avgAllPulse);
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            if (appDelegate.isDeviceAniPhone4 == NO)
            {
                int y = avgAllPulse*150/100;
                
                avgPulseLine.frame = CGRectMake(50, 150+48 - y, 298, 1);
                
                avgPulseTxtLbl.frame = CGRectMake(0, 150+48-y-21, 30, 21);
                avgPulseValueLbl.frame = CGRectMake(0, 150+48-y, 30, 21);

            }else{
           
                int y = avgAllPulse*150/100;
                
                avgPulseLine.frame = CGRectMake(50, 150+48 - y, 298, 1);
                
                avgPulseTxtLbl.frame = CGRectMake(0, 150+48-y-21, 30, 21);
                avgPulseValueLbl.frame = CGRectMake(0, 150+48-y, 30, 21);
            }
        }else{
            int y = avgAllPulse*300/100;
            
            avgPulseLine.frame = CGRectMake(50, 300+94 - y, 750, 1);
            
            avgPulseTxtLbl.frame = CGRectMake(0, 300+94-y-21, 30, 21);
            avgPulseValueLbl.frame = CGRectMake(0, 300+94-y, 30, 21);
            
        }
                
        avgPulseValueLbl.text = [NSString stringWithFormat:@"%d",avgAllPulse];
        
        for (int g = barChartValue_Arr.count; g < 10; g++) {
            [barChartValue_Arr addObject:@"0"];
            [barChartValueColor_Arr addObject:@"BEC5CD"];
        }
//        NSLog(@"barChartValue_Arr %@ - %@",barChartValue_Arr, barChartValueColor_Arr);
    }
    
    if (sortedDB_Arr.count > 0) {
        //Load the Bar Chart - you can either load it using an NSArray or an XML File
        dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
        dispatch_async(myQueue, ^{
            // Perform long running process
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [self loadBarChartUsingArray];
                [tbl reloadData];
                
                
            });
        });
    }else{
        barChart.hidden = YES;
    }

}
//------------------------------------------------------//
//--- Bar Chart Setup ----------------------------------//
//------------------------------------------------------//
#pragma mark - Bar Chart Setup

- (void)loadBarChartUsingArray {

//    NSLog(@"barChartValue_Arr %@",barChartValue_Arr);
    NSArray *array = [barChart createChartDataWithTitles:[NSArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"",  nil]
                                                  values:[NSArray arrayWithArray:[barChartValue_Arr mutableCopy]]
                                                  colors:[NSArray arrayWithArray:[barChartValueColor_Arr mutableCopy]]
                                             labelColors:[NSArray arrayWithObjects:@"FFFFFF", @"FFFFFF", @"FFFFFF", @"FFFFFF", @"FFFFFF",@"FFFFFF",@"FFFFFF",@"FFFFFF",@"FFFFFF",@"FFFFFF", nil]];
    
    //Set the Shape of the Bars (Rounded or Squared) - Rounded is default
    [barChart setupBarViewShape:BarShapeSquared];
    
    //Set the Style of the Bars (Glossy, Matte, or Flat) - Glossy is default
    [barChart setupBarViewStyle:BarStyleFlat];
    
    //Set the Drop Shadow of the Bars (Light, Heavy, or None) - Light is default
    [barChart setupBarViewShadow:BarShadowNone];
    
    //Generate the bar chart using the formatted data
    [barChart setDataWithArray:array
                      showAxis:DisplayBothAxes
                     withColor:[UIColor clearColor]
       shouldPlotVerticalLines:NO];
}
-(NSMutableArray *)SortDateArr:(NSMutableArray *)Arr SectionData:(NSArray *)Section_Arr{
    NSMutableArray *finalArr = [[NSMutableArray alloc] init];

    if (Section_Arr.count > 0) {
        for (int i = 0; i < Section_Arr.count; i++) {
            NSMutableDictionary *sectionWiseDic = [[NSMutableDictionary alloc] init];
            
            
            NSString *sectionStr = [Section_Arr objectAtIndex:i];
            
            [sectionWiseDic setObject:sectionStr forKey:@"section"];
            
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            int totalPulseSectionCount = 0;
            int avgPulseSectionCount = 0;
            
            for (int j = 0; j < Arr.count; j++) {
                NSString *tempSectionStr  = [[Arr objectAtIndex:j] valueForKey:@"section_date"];
                if ([tempSectionStr isEqualToString:sectionStr]) {
                    [tempArr addObject:[Arr objectAtIndex:j]];
                    totalPulseSectionCount = totalPulseSectionCount + [[[Arr objectAtIndex:j] valueForKey:@"heartbeat"] integerValue];
                }
            }
            
            avgPulseSectionCount = totalPulseSectionCount/tempArr.count;
            
            [sectionWiseDic setObject:tempArr forKey:@"setion_data"];
            [sectionWiseDic setObject:[NSString stringWithFormat:@"%d",avgPulseSectionCount] forKey:@"avgPulseSectionCount"];
            
            [finalArr addObject:sectionWiseDic];
        }
    }
    return finalArr;
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [sortedDB_Arr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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
    MonthHeaderTitle.textColor=[UIColor colorWithRed:204.0/255.0 green:0/255.0 blue:0/255.0 alpha:1];

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
    avgBeatHeaderTitle.textColor = [UIColor colorWithRed:64/255.0 green:136/255.0 blue:203/255.0 alpha:1.0];
    avgBeatHeaderTitle.textColor=[UIColor colorWithRed:204.0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    [headerView addSubview:avgBeatHeaderTitle];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[sortedDB_Arr objectAtIndex:section] valueForKey:@"setion_data"] count];
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
    
    static NSString *myIdentifire = @"HistoryTableViewCell";
    HistoryTableViewCell *historyTableViewCell = (HistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:myIdentifire];
    
    if (historyTableViewCell == nil){
        NSArray *nib;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell_iPhone" owner:self options:nil];
        }else{
            nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell_iPad" owner:self options:nil];
        }
        historyTableViewCell = (HistoryTableViewCell *)[nib objectAtIndex:0];
    }
    
    if ([[[[[sortedDB_Arr objectAtIndex:indexPath.section] valueForKey:@"setion_data"] objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"1"] ) {
        
        historyTableViewCell.typeImgView.image = [UIImage imageNamed:@"General1.png"];
        
        historyTableViewCell.titleLbl.text = NSLocalizedStringFromTableInBundle(@"General", @"Localizable", [AppDelegate GetLocalizebundle], @"");
        
        historyTableViewCell.titleLbl.textColor=[UIColor colorWithRed:204.0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
    else if ([[[[[sortedDB_Arr objectAtIndex:indexPath.section] valueForKey:@"setion_data"] objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"2"] ) {
        historyTableViewCell.typeImgView.image = [UIImage imageNamed:@"Resting_HR.png"];
        historyTableViewCell.titleLbl.text = NSLocalizedStringFromTableInBundle(@"Resting HR", @"Localizable", [AppDelegate GetLocalizebundle], @"");
        historyTableViewCell.titleLbl.textColor=[UIColor colorWithRed:204.0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
    else if ([[[[[sortedDB_Arr objectAtIndex:indexPath.section] valueForKey:@"setion_data"] objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"3"] ) {
        historyTableViewCell.typeImgView.image = [UIImage imageNamed:@"beforesport.png"];
        historyTableViewCell.titleLbl.text = NSLocalizedStringFromTableInBundle(@"Before Sport", @"Localizable", [AppDelegate GetLocalizebundle], @"");
        historyTableViewCell.titleLbl.textColor=[UIColor colorWithRed:204.0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
    else if ([[[[[sortedDB_Arr objectAtIndex:indexPath.section] valueForKey:@"setion_data"] objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"4"] ) {
        historyTableViewCell.typeImgView.image = [UIImage imageNamed:@"afterpost.png"];
        historyTableViewCell.titleLbl.text = NSLocalizedStringFromTableInBundle(@"After Sport", @"Localizable", [AppDelegate GetLocalizebundle], @"");
        historyTableViewCell.titleLbl.textColor=[UIColor colorWithRed:204.0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
    else if ([[[[[sortedDB_Arr objectAtIndex:indexPath.section] valueForKey:@"setion_data"] objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"5"] ) {
        historyTableViewCell.typeImgView.image = [UIImage imageNamed:@"maxhigh.png"];
        historyTableViewCell.titleLbl.text = NSLocalizedStringFromTableInBundle(@"Max HR", @"Localizable", [AppDelegate GetLocalizebundle], @"");
        historyTableViewCell.titleLbl.textColor=[UIColor colorWithRed:204.0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
    else
    {
        historyTableViewCell.typeImgView.image = [UIImage imageNamed:@"General1.png"];
        historyTableViewCell.titleLbl.text = NSLocalizedStringFromTableInBundle(@"General", @"Localizable", [AppDelegate GetLocalizebundle], @"");
        historyTableViewCell.titleLbl.textColor=[UIColor colorWithRed:204.0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
   
    historyTableViewCell.dateLbl.text = [[[[sortedDB_Arr objectAtIndex:indexPath.section] valueForKey:@"setion_data"] objectAtIndex:indexPath.row] valueForKey:@"date"];
    if ([[[[[sortedDB_Arr objectAtIndex:indexPath.section] valueForKey:@"setion_data"] objectAtIndex:indexPath.row] valueForKey:@"heartbeat"] length] == 2) {
        
        historyTableViewCell.avgLbl.text = [NSString stringWithFormat:@"0%@",[[[[sortedDB_Arr objectAtIndex:indexPath.section] valueForKey:@"setion_data"] objectAtIndex:indexPath.row] valueForKey:@"heartbeat"]];
    }else{
        historyTableViewCell.avgLbl.text = [[[[sortedDB_Arr objectAtIndex:indexPath.section] valueForKey:@"setion_data"] objectAtIndex:indexPath.row] valueForKey:@"heartbeat"];
    }
    return historyTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if ([self isDeviceAniPhone4] == YES) {

                detailViewController = [[DetailViewController alloc] initWithNibName:@"detailview4s_iphone" bundle:nil];
           }
        else
        {
            detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];
        }
    }
        else
        
        {
            
        detailViewController = [[DetailViewController alloc]initWithNibName:@"DetailViewController_iPad" bundle:nil];
    }
      detailViewController.historyDic = [[[sortedDB_Arr objectAtIndex:indexPath.section] valueForKey:@"setion_data"] objectAtIndex:indexPath.row];
    appDelegate.fromMainView = NO;
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
}
@end
