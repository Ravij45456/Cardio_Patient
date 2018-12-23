#import "AdMobViewController.h"
#import "AppDelegate.h"

@interface AdMobViewController ()

@end

@implementation AdMobViewController
@synthesize adBanner = adBanner_,ObjInterstitial;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [self callAdMob];
    
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    btnRemoveAdd = [[UIButton alloc] initWithFrame:CGRectMake(290,0, 32, 28)];
  
    

    [super viewDidLoad];
}

-(void)callAdMob
{
        CGPoint origin;
        origin = CGPointMake(0.0,0.0);
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard origin:origin];
        
    }else{
        self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    }
    
        self.adBanner.adUnitID = BANNER_AD_UNIT_ID;
        self.adBanner.delegate = self;
        [self.adBanner setRootViewController:self];
        [self.view addSubview:self.adBanner];
        [self.adBanner loadRequest:[appDelegate createRequest]];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark GADBannerViewDelegate impl

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView
{
//    NSLog(@"Received ad successfully");
    if (![btnRemoveAdd superview])
    {
    
        UIImage *btnSelectImage = [UIImage imageNamed:@"banner-close-btn.png"];
        [btnRemoveAdd setBackgroundImage:btnSelectImage forState:UIControlStateNormal];
        
//        [btnRemoveAdd addTarget:self action:@selector(RemoveAdd:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnRemoveAdd];
        [self.view bringSubviewToFront:btnRemoveAdd];        
    }
}
//-(IBAction)RemoveAdd:(id)sender
//{
//    [appDelegate requestForInAppPurchaseFull];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoveBanner) name: @"RemoveBanner" object:nil];
//}
//-(void)RemoveBanner
//{
//    NSLog(@"RemoveBanner");
//    if (appDelegate.isInAppPurchased)
//    {
//        if ([btnRemoveAdd superview])
//        {
//            [btnRemoveAdd removeFromSuperview];
//        }
//        if ([self.adBanner superview])
//        {
//            [self.adBanner removeFromSuperview];
//        }
//    }
//}
- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
