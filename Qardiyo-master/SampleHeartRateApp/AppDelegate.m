#import "AppDelegate.h"
#import "ViewController.h"
#import "HistoryViewController.h"
#import "InformationViewController.h"
#import "DetailViewController.h"
#import "SettingviewController.h"
#import "settingcustome.h"


static NSBundle *myLocalizedBundle;
static NSString *lan;

static NSString *const kTrackingId = @"UA-22506228-23";
static NSString *const kAllowTracking = @"allowTracking";
@class ViewController;

@interface AppDelegate ()
{
    NSString *avgplusRate;
}
@end

@implementation AppDelegate

@synthesize heartBeatValue, fromMainView;
@synthesize interstensialAdDsiplayCount;
@synthesize selectedLanguageCode;
@synthesize isCameraPermission;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    [self CheckCameraPermission];

    //Database====================================================================================================
    NSString *storePath = [self filePath:@"HeartRateApp.sqlite"];
//    NSLog(@"storePath_Database %@",storePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:storePath]){
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"HeartRateApp" ofType:@"sqlite"];
        if (defaultStorePath){
            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
        }
    }
    //====================================================================================================
    
    flag=0;
    
    fromMainView = NO;
    heartBeatValue = 0;
    interstensialAdDsiplayCount = 4;
    
     [self GetAppLang];
    
    //----------------------------------------------------------------------------------
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    // User must be able to opt out of tracking
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    // Initialize Google Analytics with a 120-second dispatch interval. There is a
    // tradeoff between battery usage and timely dispatch.
    [GAI sharedInstance].dispatchInterval = 120;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithName:@"HeartRate App"
                                              trackingId:kTrackingId];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"HeartRate App"
                                                          action:@"App Launch"
                                                           label:@"Launching App"
                                                           value:nil] build]];
    
    id<GAITracker> trackerA = [[GAI sharedInstance] defaultTracker];
    [trackerA set:kGAIScreenName value:@"/App_Launch"];
    [trackerA send:[[GAIDictionaryBuilder createAppView] build]];
    //----------------------------------------------------------------------------------
    
    //----------------------------------------------------------------------------------
//    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstTime"] isEqualToString:@"YES"]){
//        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"isfullPackPurchased"];
//        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"isFirstTime"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"isfullPackPurchased"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    //--------------------------------------------------------------------------
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if ([self isDeviceAniPhone4] == YES) {
            
            self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_4S_iPhone" bundle:nil];
        }else
        {
            self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
        }
        

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            
            if ([self isDeviceAniPhone4] == YES) {
                
                self.historyViewController = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController4s_iPhone" bundle:nil];
                
            }
            
            else{
                
                self.historyViewController = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController_iPhone" bundle:nil];
                
            }
        }
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            
            if ([self isDeviceAniPhone4] == YES) {
                
                 self.SettingviewController = [[SettingviewController alloc] initWithNibName:@"setting4s_iphone" bundle:nil];
                
            }
            
            else{
                
                 self.SettingviewController = [[SettingviewController alloc] initWithNibName:@"SettingviewController_iPhone1" bundle:nil];
                
            }
        }
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            
            if ([self isDeviceAniPhone4] == YES) {
                
               self.informationViewController = [[InformationViewController alloc] initWithNibName:@"infoview4s_iphone" bundle:nil];
                
            }
            
            else{
                
                self.informationViewController = [[InformationViewController alloc] initWithNibName:@"InformationViewController_iPhone1" bundle:nil];
                
            }
        }


        
       
        
        
        
       
        
        
    } else {
        
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
        
        self.historyViewController = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController_iPad" bundle:nil];
        
        self.InformationViewController = [[InformationViewController alloc] initWithNibName:@"InformationViewController_iPad1" bundle:nil];
        
        self.SettingviewController = [[SettingviewController alloc] initWithNibName:@"SettingviewController_ipad" bundle:nil];
        
    }
    //settabbar
    UIViewController *HomeController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    UINavigationController *HistoryController = [[UINavigationController alloc] initWithRootViewController:self.historyViewController];
    
    UIViewController *InfoController = [[UINavigationController alloc] initWithRootViewController:self.InformationViewController];
    
    
    UIViewController *SettingController = [[UINavigationController alloc] initWithRootViewController:self.SettingviewController];
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    
    self.tabBarController.delegate = self;
   
   [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:204.0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    
 
    self.tabBarController.viewControllers = @[HomeController, HistoryController, InfoController,SettingController];
    
    self.tabBarController.selectedIndex = 0;
//    self.tabBarController.selectedViewController.tabBarItem.title = @"Home";
//    
//    self.tabBarController.selectedViewController.tabBarItem.title = NSLocalizedStringFromTableInBundle(@"General", @"Localizable", [AppDelegate GetLocalizebundle], @"");
    
    [[[self.tabBarController.viewControllers objectAtIndex:0] tabBarItem] setImage:[UIImage imageNamed:@"home@2x.png"]];
    
    
    
    self.tabBarController.selectedIndex = 1;
    self.tabBarController.selectedViewController.tabBarItem.title = @"History";
    [[[self.tabBarController.viewControllers objectAtIndex:1] tabBarItem] setImage:[UIImage imageNamed:@"history@2x.png"]];
    
    self.tabBarController.selectedIndex = 2;
    self.tabBarController.selectedViewController.tabBarItem.title = @"Info";
    [[[self.tabBarController.viewControllers objectAtIndex:2] tabBarItem] setImage:[UIImage imageNamed:@"info@2x.png"]];
    
    self.tabBarController.selectedIndex = 3;
    self.tabBarController.selectedViewController.tabBarItem.title = @"Settings";
    [[[self.tabBarController.viewControllers objectAtIndex:3] tabBarItem] setImage:[UIImage imageNamed:@"setting@2xx.png"]];
    
    self.tabBarController.selectedIndex = 0;
    self.window.rootViewController = self.tabBarController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}
+(BOOL)isAppPurchased{
    
    if ([[NSUserDefaults standardUserDefaults]  boolForKey:@"isfullPackPurchased"] == YES)
        return YES;
    else
        return NO;
}
- (NSString *)interstitialAdUnitID {
    return INTERSTITIAL_AD_UNIT_ID;
}


//---------------- FILE PATH ACTION ----------------//
-(NSString *)filePath:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:fileName];
}

#pragma mark - Current Date and Time
-(NSString *)CurrentDateTime{
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"dd/MM/yyyy HH:mm a"];
    NSString *dateInStringFormated=[dateformatter stringFromDate:[NSDate date]];
//    NSLog(@"%@",dateInStringFormated);
    
    return dateInStringFormated;
}

#pragma mark - Check iPhone Size
- (BOOL)isDeviceAniPhone5{
    BOOL isiPhone5 = CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136));
    return isiPhone5;
}

- (BOOL)isDeviceAniPhone4{
    BOOL isiPhone5 = CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 960));
    return isiPhone5;
}

#pragma mark - Ad View


- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as
    // well as any devices you want to receive test ads.
    request.testDevices = [NSArray arrayWithObjects:@"eb6a6e1eaec6daf777d8466bb72e4b72", nil];
    return request;
}

#pragma mark - Language Localise
#pragma mark
#pragma mark - Application language
-(void) GetAppLang{
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    //NSLog(@"currentLanguage %@",currentLanguage);
    
    if (![currentLanguage isEqualToString:@"zh-Hans"] && ![currentLanguage isEqualToString:@"zh-Hant"] )
    {
        if ([currentLanguage rangeOfString:@"-"].location != NSNotFound) {
            currentLanguage = [[currentLanguage componentsSeparatedByString:@"-"] objectAtIndex:0];
        }
    }
    
    if([currentLanguage isEqualToString:@"de"])
    {
        [self GetLangKey:@"de"];
        selectedLanguageCode = @"de";
    }
    else if([currentLanguage isEqualToString:@"fr"])
    {
        [self GetLangKey:@"fr"];
        selectedLanguageCode = @"fr";
    }
    else if([currentLanguage isEqualToString:@"es"])
    {
        [self GetLangKey:@"es"];
        selectedLanguageCode = @"es";
    }
    else if([currentLanguage isEqualToString:@"it"])
    {
        [self GetLangKey:@"it"];
        selectedLanguageCode = @"it";
    }
    else if([currentLanguage isEqualToString:@"pt"])
    {
        [self GetLangKey:@"pt"];
        selectedLanguageCode = @"pt";
    }
    else if([currentLanguage isEqualToString:@"ja"])
    {
        [self GetLangKey:@"ja"];
        selectedLanguageCode = @"ja";
    }
    else if([currentLanguage isEqualToString:@"ko"])
    {
        [self GetLangKey:@"ko"];
        selectedLanguageCode = @"ko";
    }
    else if([currentLanguage isEqualToString:@"ru"])
    {
        [self GetLangKey:@"ru"];
        selectedLanguageCode = @"ru";
    }
    else if([currentLanguage isEqualToString:@"nl"])
    {
        [self GetLangKey:@"nl"];
        selectedLanguageCode = @"nl";
    }
    else if([currentLanguage isEqualToString:@"zh-Hans"])
    {
        [self GetLangKey:@"zh-Hans"];
        selectedLanguageCode = @"zh-Hans";
    }
    else if([currentLanguage isEqualToString:@"zh-Hant"])
    {
        [self GetLangKey:@"zh-Hant"];
        selectedLanguageCode = @"zh-Hant";
    }
    else
    {
        //"en"
        [self GetLangKey:@"en"];
        selectedLanguageCode = @"en";
    }
}

- (void)GetLangKey:(NSString *)Langkey{
    lan = Langkey;
    NSString *tmpstr = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle]pathForResource:@"LangResource" ofType:@"bundle"]];
    tmpstr = [tmpstr stringByAppendingString:@"/"];
    tmpstr = [tmpstr stringByAppendingString:Langkey];
    tmpstr = [tmpstr stringByAppendingString:@".lproj"];
    myLocalizedBundle = [NSBundle bundleWithPath:tmpstr];
}


+ (NSString*)GetLanguage{
    return lan;
}


+ (NSBundle *)GetLocalizebundle{
    return myLocalizedBundle;
}

- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self CheckCameraPermission];

    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    //    NSLog(@"%@",[d valueForKey:@"a"]);
    
    if ([[d valueForKey:@"automaticLightON"] isEqualToString:@"no"])
    {
        [self.viewController startCameraCapture];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}
- (void)applicationWillTerminate:(UIApplication *)application {}


-(void)CheckCameraPermission
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == AVAuthorizationStatusAuthorized)
    {
        // do your logic
        isCameraPermission = YES;
    }
    else if(authStatus == AVAuthorizationStatusDenied)
    {
        // denied
        isCameraPermission = NO;
    }
    else if(authStatus == AVAuthorizationStatusRestricted)
    {
        // restricted, normally won't happen
        isCameraPermission = NO;
    }
    else if(authStatus == AVAuthorizationStatusNotDetermined)
    {
        // not determined?!
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted)
            {
                NSLog(@"Granted access to %@", AVMediaTypeVideo);
                isCameraPermission = YES;
            }
            else
            {
                NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                isCameraPermission = NO;
            }
        }];
    }
    else
    {
        // impossible, unknown authorization status
        isCameraPermission = NO;
    }
}


@end
