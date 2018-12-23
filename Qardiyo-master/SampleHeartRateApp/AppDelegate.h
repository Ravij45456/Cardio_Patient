//
//  AppDelegate.h
//  SampleHeartRateApp
//
//  Created by chris on 08/03/2015.
//  Copyright (c) 2015 CMG Research Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Constants.h"
#import "ViewController.h"

@class ViewController;
@class HistoryViewController;
@class InformationViewController;
@class DetailViewController;
@class SettingviewController;


@interface AppDelegate : UIResponder <UIApplicationDelegate, GADInterstitialDelegate, UIPageViewControllerDelegate>{
    UIViewController *aTempVisibleVC;
    
    int flag;
    BOOL isCameraPermission;
}

@property(nonatomic, assign) int flag;

@property(nonatomic, retain) GADInterstitial *interstitial;

@property(nonatomic , assign) int DurationOfVideo, InfoInterstitial ,PreviewInterstitial ;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) HistoryViewController *historyViewController;
@property (strong, nonatomic) DetailViewController *detailviewController;
@property (strong, nonatomic) InformationViewController *InformationViewController;
@property (strong, nonatomic) SettingviewController *SettingviewController;
- (instancetype)initWithAdUnitID:(NSString *)adUnitID NS_DESIGNATED_INITIALIZER;
+(BOOL)isAppPurchased;
@property (nonatomic, retain) NSString *selectedLanguageCode;


@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic, assign) BOOL fromMainView;

@property (nonatomic, assign) float heartBeatValue;

@property (nonatomic,readwrite) BOOL isCameraPermission;


-(NSString *)CurrentDateTime;
- (BOOL)isDeviceAniPhone5;
- (BOOL)isDeviceAniPhone4;


@property (readwrite) int interstensialAdDsiplayCount;
@property(nonatomic, readonly) NSString *interstitialAdUnitID;
- (GADRequest *)createRequest;

@property(nonatomic, strong) id<GAITracker> tracker;

- (void)GetLangKey:(NSString *)Langkey;
+ (NSBundle *)GetLocalizebundle;
+ (NSString*)GetLanguage;
@end

