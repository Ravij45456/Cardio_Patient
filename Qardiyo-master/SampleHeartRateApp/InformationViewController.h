//
//  InformationViewController.h
//  Heart Rate
//
//  Created by Mahesh Patel on 24/10/15.
//  Copyright © 2015 CMG Research Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "InAppPurchaser.h"

// Interstitial Ad
#import <GoogleMobileAds/GADInterstitial.h>
#import <GoogleMobileAds/GADInterstitialDelegate.h>

@class AdMobViewController;
@class AppDelegate;


@interface InformationViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate,GADInterstitialDelegate, UINavigationControllerDelegate>{
    IBOutlet UITableView *infoTableView;
    IBOutlet UIView *admobView;
    
    int intCheckView;
    // Set 1 for Send Feedback, 2 for Tell a Friend
    AppDelegate *AppDelObj ;
     InAppPurchaser* m_InAppStore;

    AdMobViewController *adMobViewController;
    
    AppDelegate *appDelegate;

    
    
    IBOutlet UIView *AdmobView;
    
    NSArray *InAppArray;
    
    
    
    CGRect LockFrame;
    CGRect UnLockFrame;
    
    int HeightOfAdmob;
}

@property(nonatomic, strong) IBOutlet UILabel *validFrames;

@property (weak, nonatomic) IBOutlet UIView *header;
@property(nonatomic, retain) GADInterstitial *interstitial;



@end
