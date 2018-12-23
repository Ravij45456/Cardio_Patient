#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <iAd/iAd.h>
#import <GoogleMobileAds/GADInterstitial.h>
#import <GoogleMobileAds/GADBannerViewDelegate.h>
#import "InAppPurchaser.h"
@class GADBannerView, GADRequest;
@class AppDelegate;
@class MyManager;

@interface AdMobViewController : UIViewController<ADBannerViewDelegate,GADBannerViewDelegate,GADInterstitialDelegate>
{
    GADBannerView *adBanner;
    AppDelegate *appDelegate;
    MyManager *sharedManager;
    UIButton *btnRemoveAdd;
    GADInterstitial *ObjInterstitial;
     InAppPurchaser* m_InAppStore;
}

@property (nonatomic, retain) GADBannerView *adBanner;
@property (nonatomic, retain) GADInterstitial *ObjInterstitial;
-(void)callAdMob;

@end
