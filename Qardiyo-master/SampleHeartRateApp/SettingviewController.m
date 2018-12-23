//
//  SettingviewController.m
//  Heart Rate
//
//  Created by Mahesh Patel on 23/10/15.
//  Copyright © 2015 CMG Research Ltd. All rights reserved.
//

#import "SettingviewController.h"
#import "DocumentsViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "AdMobViewController.h"
#import "settingcustome.h"
#import "DatabaseManager.h"

@interface SettingviewController ()
@end
@implementation SettingviewController
@synthesize arr_setting,tbl_data,AppleHeath;
@synthesize measurementTypeInt, feelType;
@synthesize additionalInfoTxt;
@synthesize avgPulse;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tbl_data.tableHeaderView =self.header;
  self.title = NSLocalizedStringFromTableInBundle(@"fourpageTitile", @"Localizable", [AppDelegate GetLocalizebundle], @"");

    [super viewDidLoad];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isfullPackPurchased"])
    {
             [admobView setHidden:TRUE];
        [admobView removeFromSuperview];
        [tbl_data setFrame:CGRectMake(0, 60, 320, 568)];
        
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
    
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger row = 0;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isfullPackPurchased"])
    {
        row = 2;
    }else{
        row = 2;
    }
    return row;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isfullPackPurchased"])
    {
        if(section == 0)
        {
            return [SettingArrayOne count];
        }else if (section == 1)
        {
           // self.switchmanage.hidden=NO;
            return [SettingArrayTwo count];
        }
        
    }else{
        if(section == 0){
            return [SettingArrayOne count];
        }
        else if (section == 1){
            return [SettingArrayTwo count];
        }
        
    }
    return 0;
}
- (void)adjustAdBannerPosition:(BOOL)animated{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isfullPackPurchased"])
    {
        [admobView setHidden:TRUE];
        [admobView removeFromSuperview];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            _validFrames.frame =  CGRectMake(10, -50, 320, 50);
        }
        else
        {
            if([appDelegate isDeviceAniPhone5])
            {
                //5
                //[tbl setFrame:CGRectMake(0.0, 235.0, 320.0, 283)];
                _validFrames.frame =  CGRectMake(0, -50, 320, 50);
            }
            else
            {
                //4s
                _validFrames.frame =  CGRectMake(0, -50, 320, 50);
            }
        }
    }
    else
    {
        [admobView setHidden:FALSE];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            _validFrames.frame = CGRectMake(10, 836, 752, 40);
            
            admobView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, -50, 320, 50)];
        }
        else
        {
            if([appDelegate isDeviceAniPhone5]){
                //iphone 5
                _validFrames.frame = CGRectMake(0, 439, 320, 21);
                admobView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, -50, 320, 50)];
            }
            else{
                //4s
                _validFrames.frame =  CGRectMake(0, -50, 320, 50);
                admobView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, -50, 320, 50)];
            }
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat Row = 0;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        Row = 50;
    }else{
        Row = 60;
    }
    return Row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    UILabel *OtherHeaderTitle = [[UILabel alloc] init];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        headerView.frame=CGRectMake(0, 0, 320,30);
        OtherHeaderTitle.frame = CGRectMake(5, -5, 300, -10);
        OtherHeaderTitle.font = [UIFont systemFontOfSize:14.0f];
      
     
    }else{
        headerView.frame = CGRectMake(0, 0, 768, 50);
        OtherHeaderTitle.frame = CGRectMake(10, 10, 748, -30);
        OtherHeaderTitle.font = [UIFont systemFontOfSize:20.0f];
        
    }
    NSString *titleHeader;
    switch (section){
        case 0:
            titleHeader = NSLocalizedStringFromTableInBundle(@"USE", @"Localizable", [AppDelegate GetLocalizebundle], @"");
            
            break;
        case 1:
            titleHeader = NSLocalizedStringFromTableInBundle(@"", @"Localizable", [AppDelegate GetLocalizebundle], @"");
            
            break;
    }
    OtherHeaderTitle.text = titleHeader;
    [OtherHeaderTitle setTextColor:[UIColor blackColor]];
    OtherHeaderTitle.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:OtherHeaderTitle];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myIdentifire = @"INFO_CELL";
    settingcustome *infoViewCellCustom = (settingcustome *)[tableView dequeueReusableCellWithIdentifier:myIdentifire];
    
    if (infoViewCellCustom == nil){
        NSArray *nib;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            nib = [[NSBundle mainBundle] loadNibNamed:@"settingcustome_iPhone" owner:self options:nil];
        }else{
            
            nib = [[NSBundle mainBundle] loadNibNamed:@"settingcustome_iPad" owner:self options:nil];
        }
        infoViewCellCustom = (settingcustome *)[nib objectAtIndex:0];
    }
        infoViewCellCustom.lbl_name.numberOfLines = 0;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isfullPackPurchased"])
    {
        if(indexPath.section == 0){
            infoViewCellCustom.selectionStyle = UITableViewCellSelectionStyleNone;
            
             infoViewCellCustom.swichmenu.hidden=YES;
            
             //self.switchmanage.hidden=YES;
            infoViewCellCustom.lbl_name.text = NSLocalizedStringFromTableInBundle([SettingArrayOne objectAtIndex:indexPath.row], @"Localizable", [AppDelegate GetLocalizebundle], @"");
           
            
            
        }else if(indexPath.section == 1){
            infoViewCellCustom.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            infoViewCellCustom.swichmenu.hidden=NO;
            if (indexPath.row==1)
            {
                infoViewCellCustom.selectionStyle = UITableViewCellSelectionStyleNone;
                   infoViewCellCustom.swichmenu.hidden=YES;
                infoViewCellCustom.lbl_name.font = [UIFont systemFontOfSize:13.0];

            }
            
            infoViewCellCustom.lbl_name.text = NSLocalizedStringFromTableInBundle([SettingArrayTwo objectAtIndex:indexPath.row], @"Localizable", [AppDelegate GetLocalizebundle], @"");
        }
           }else{
        if(indexPath.section == 0) {
        
            infoViewCellCustom.swichmenu.hidden=YES;

            infoViewCellCustom.lbl_name.text = NSLocalizedStringFromTableInBundle([SettingArrayOne objectAtIndex:indexPath.row], @"Localizable", [AppDelegate GetLocalizebundle], @"");
           //infoViewCellCustom.image.image=[UIImage imageNamed:@"about@2x.png"];
            
        }
        else if(indexPath.section == 1){
            infoViewCellCustom.selectionStyle = UITableViewCellSelectionStyleNone;
            
            infoViewCellCustom.swichmenu.hidden=NO;
            
            infoViewCellCustom.lbl_name.text = NSLocalizedStringFromTableInBundle([SettingArrayTwo objectAtIndex:indexPath.row], @"Localizable", [AppDelegate GetLocalizebundle], @"");
            if (indexPath.row==0) {
                
//                infoViewCellCustom.swichmenu.hidden=NO;
                
                [infoViewCellCustom.swichmenu addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            }
            else if (indexPath.row==1)
            {
                infoViewCellCustom.swichmenu.hidden=YES;
                infoViewCellCustom.lbl_name.font = [UIFont systemFontOfSize:13.0];
            }
         
        }
    }
    return infoViewCellCustom;
}
- (IBAction)changeSwitch:(id)sender{
    
    if([sender isOn]){
        NSLog(@"Switch is ON");
        NSMutableArray *getAllDB_Arr = [DBManager getAllDataUsingQuery:@"SELECT * FROM HistoryData"];
        if (getAllDB_Arr.count > 9) {
            NSMutableArray *getMinIDDB_Arr = [DBManager getAllDataUsingQuery:@"SELECT MIN(id) FROM HistoryData"];
            
            BOOL checkDel = [DBManager delRecordFromTable:@"HistoryData" recordName:@"id" recordID:[[[getMinIDDB_Arr objectAtIndex:0] valueForKey:@"MIN(id)"] integerValue]];
            if (checkDel == 1) {
                NSLog(@"Delete 1 record");
            }else{
                NSLog(@"Nothing Delete");
            }
        }
        
        NSString *insertDeleteRecord = [NSString stringWithFormat:@"INSERT INTO HistoryData (heartbeat, date, type, feeling, info) values ('%@', '%@', '%@', '%@', '%@')", [NSString stringWithFormat:@"%d",avgPulse], [appDelegate CurrentDateTime], [NSString stringWithFormat:@"%d",measurementTypeInt], [NSString stringWithFormat:@"%d",feelType], additionalInfoTxt.text];
        
        [DBManager insertValueIntoTable:insertDeleteRecord err:@"Error"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
        
        if(NSClassFromString(@"HKHealthStore") && [HKHealthStore isHealthDataAvailable])
        {
            
            NSSet *shareObjectTypes = [NSSet setWithObjects:
                                       [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
                                       nil];
            
            // Read date of birth, biological sex and step count
            NSSet *readObjectTypes  = [NSSet setWithObjects:
                                       [HKObjectType characteristicTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
                                       nil];
            
            // Request access
            [healthStore requestAuthorizationToShareTypes:shareObjectTypes
                                                readTypes:readObjectTypes
                                               completion:^(BOOL success, NSError *error) {
                                                   
                                                   if(success == YES)
                                                   {
                                                       // ...
                                                       NSLog(@"success");
                                                       [self heakthKit];
                                                   }
                                                   else
                                                   {
                                                       // Determine if it was an error or if the
                                                       // user just canceld the authorization request
                                                       NSLog(@"error - %@",error);
                    }
            }];
        }

    } else{
        
    NSLog(@"Switch is OFF");
    }
}
-(void)heakthKit {
    
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
        double weightInGram = avgPulse;
    // Add your HealthKit code here
    NSDate          *now = [NSDate date];
    HKQuantityType  *hkQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:avgPulse
                  forKey:@"avgPulse"];
// NSLog(@"datamanage%@",defaults);
    [defaults synchronize];
    //NSLog(@"..............%@",[defaults valueForKey:@"avgPulse"]);
    HKUnit *bpm = [HKUnit unitFromString:@"count/min"];
    
    HKQuantity *quantity = [HKQuantity quantityWithUnit:bpm doubleValue:weightInGram];
    
    NSDictionary *metadata = nil;
    
    HKQuantitySample *weightSample =
    [HKQuantitySample quantitySampleWithType:hkQuantityType
                                    quantity:quantity
                                   startDate:now
                                     endDate:now
                                    metadata:metadata];
    
    [healthStore saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
        if(success == YES){
            NSLog(@"Successfully Store in Health Kit");
        }else{
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            
            DocumentsViewController *documentsViewController;
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                documentsViewController = [[DocumentsViewController alloc] initWithNibName:@"DocumentsViewController_iPhone" bundle:nil];
            }else{
                documentsViewController = [[DocumentsViewController alloc]initWithNibName:@"DocumentsViewController_iPad" bundle:nil];
            }
            documentsViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:documentsViewController animated:YES];
        }
    }
        else if(indexPath.section == 2){
            
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
