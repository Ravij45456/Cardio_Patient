//
//  SettingviewController.h
//  Heart Rate
//
//  Created by Mahesh Patel on 23/10/15.
//  Copyright © 2015 CMG Research Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocumentsViewController.h"
#import "AdMobViewController.h"
#import "AppDelegate.h"
#import <HealthKit/HealthKit.h>
@class AppDelegate;

@class DocumentsViewController;
@class SettingViewCellCustom;
@class DocumentsViewController;
@class AppDelegate;

@interface SettingviewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
       AdMobViewController *adMobViewController;
    __weak IBOutlet UIView *haedrview;
    IBOutlet UIView *admobView;
    AppDelegate *appDelegate;

    DatabaseManager *DBManager;
    CGRect LockFrame;
    CGRect UnLockFrame;
      AppDelegate *AppDelObj ;
   
    
    int HeightOfAdmob;


}
@property(nonatomic,retain)UISwitch *switchmanage;

@property (nonatomic, assign) int measurementTypeInt;
@property (nonatomic, readwrite) int avgPulse;

@property (nonatomic, assign) int feelType;

@property (nonatomic, retain) IBOutlet UITextField *additionalInfoTxt;
@property(nonatomic,strong)NSMutableArray *arr_setting;
@property(nonatomic,strong)NSMutableArray *AppleHeath;
@property(nonatomic, strong) IBOutlet UILabel *validFrames;

@property (weak, nonatomic) IBOutlet UIView *header;


@property (weak, nonatomic) IBOutlet UITableView *tbl_data;
@property (strong, nonatomic) DocumentsViewController *DocumentsViewController;
@property (strong, nonatomic) SettingViewCellCustom *SettingViewCellCustom;




@end
