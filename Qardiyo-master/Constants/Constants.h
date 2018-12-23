#import <Foundation/Foundation.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define redColour [UIColor colorWithRed:215/255.0f green:39/255.0f blue:0/255.0f alpha:1.0]

#define infoScreenArray [NSArray arrayWithObjects:@"About Us",@"Send Feedback",@"iTunes Review",@"Tell a Friend", @"More Apps", nil]

#define infoarray [NSArray arrayWithObjects:@"About Us",@"Send Feedback", nil]

#define infoScreenImages [NSArray arrayWithObjects:@"aboutapp.png",@"feedback.png", nil]

#define ManageArray [NSArray arrayWithObjects:@"How it Work?",@"Apple Health", nil]


#define SettingArrayOne [NSArray arrayWithObjects:@"Itworks", nil]



#define SettingArrayTwo [NSArray arrayWithObjects:@"Apple",@"Share1", nil]

#define SettingImageOne [NSArray arrayWithObjects:@"aboutapp.png", nil]



#define infoScreenImagesArray1 [NSArray arrayWithObjects:@"about1.png",@"about1.png",@"",@"", nil]

#define infoScreenImagesArray [NSArray arrayWithObjects:@"aboutapp.png",@"feedback.png",@"itunes.png",@"friend.png", @"moreapps.png", nil]

#define itsWorkArray [NSArray arrayWithObjects:@"Remove Ads",@"Restore", nil]
#define itsWorkImagesArray [NSArray arrayWithObjects:@"unlock@2x.png",@"restore@2x-1.png", nil]




#define unlockAd_inAppPurchaseID @"com.appaspect.heartratemonitor.removeAds"

#define Is_Ipad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)
#define Is_Iphone5 ([UIScreen mainScreen].bounds.size.height == 568.0)
#define Is_Iphone4 ([UIScreen mainScreen].bounds.size.height == 480.0)
#define Is_Iphone6 ([UIScreen mainScreen].bounds.size.height == 667.0)
#define Is_Iphone6Plus ([UIScreen mainScreen].bounds.size.height == 736.0)


#define appleHearthArray [NSArray arrayWithObjects:@"Restore", nil]
#define appleHearthImagesArray [NSArray arrayWithObjects:@"aboutapp.png", nil]

#define appWebsiteURL @"http://www.appaspect.com/about-us/"
#define iTunesURL @"itms://itunes.apple.com/app/heart-rate-monitor-instant/id990587202?ls=1&mt=8"
#define feedbackEmailURL @"apps@appaspect.com"

#define moreAppsLinkArray @"itms://itunes.com/apps/gurupritsinghsaini"

#define inAppPurchaseID @"com.appaspect.heartratemonitor.removeAds"

#define ProServicesArray [NSArray arrayWithObjects:@"Remove Ads",@"Restore",nil]
#define ProServicesArrayImages [NSArray arrayWithObjects:@"unlock.png",@"restore.png",nil]

#define INTERSTITIAL_AD_UNIT_ID @"ca-app-pub-7815307424062720/7334226553"
#define BANNER_AD_UNIT_ID @"ca-app-pub-7815307424062720/5857493356"

@interface Constants : NSObject

@end
