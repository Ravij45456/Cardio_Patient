//
//  InformationViewController.m
//  Heart Rate
//
//  Created by Mahesh Patel on 24/10/15.
//  Copyright © 2015 CMG Research Ltd. All rights reserved.
//

#import "InformationViewController.h"
#import "AppDelegate.h"
#import "AdMobViewController.h"
#import "InfoViewCellCustom.h"
#import "Constants.h"
#import "DocumentsViewController.h"
#import "InAppPurchaser.h"

@interface InformationViewController ()

@end

@implementation InformationViewController
@synthesize header;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - GADInterstitial Methods
- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error {
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial{
    [interstitial presentFromRootViewController:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification) name:@"EVENT_PURCHASE_OVER" object:nil];
    
    
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    [d setValue:@"yes" forKey:@"automaticLightON"];
    [d synchronize];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isfullPackPurchased"])
    {
        [admobView setHidden:TRUE];
        [admobView removeFromSuperview];
        
        [infoTableView setFrame:CGRectMake(0, 60, 320, 568)];

    }
    else
    {
        adMobViewController=[[AdMobViewController alloc] init];
        [admobView addSubview:adMobViewController.view];
        [self addChildViewController:adMobViewController];
        
    }
    
     [self.view addSubview:admobView];
    
    id<GAITracker> trackerA = [[GAI sharedInstance] defaultTracker];
    [trackerA set:kGAIScreenName value:@"/InformationViewController"];
    [trackerA send:[[GAIDictionaryBuilder createAppView] build]];
   
    }


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedStringFromTableInBundle(@"Thirdpagetitile", @"Localizable", [AppDelegate GetLocalizebundle], @"");
   }
-(void)receiveTestNotification
{
    [infoTableView setFrame:CGRectMake(0, 60, 320, 568)];
    admobView.hidden=true;
}
- (void)adjustAdBannerPosition:(BOOL)animated{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isfullPackPurchased"])
    {
        [admobView setHidden:TRUE];
        [admobView removeFromSuperview];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            _validFrames.frame =  CGRectMake(0, -50, 320, 50);
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
            _validFrames.frame = CGRectMake(8, 836, 752, 40);
            
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)checkInApp{
    
    if ([AppDelegate isAppPurchased]) {
        
        infoTableView.frame = UnLockFrame;
        [AdmobView removeFromSuperview];
    }
    else
    {
        infoTableView.frame = LockFrame;
    }
    
    [self setadmobFrame];
}
-(void)setadmobFrame{
    
    [AdmobView setBackgroundColor:[UIColor clearColor]];
    
    if (Is_Iphone4 || Is_Iphone5) {
        AdmobView.frame = CGRectMake(0, AdmobView.frame.origin.y, 320, 50);
    }
    else if (Is_Iphone6){
        AdmobView.frame = CGRectMake(28,AdmobView.frame.origin.y, 320, 50);
        
    }
    else if (Is_Iphone6Plus){
        AdmobView.frame = CGRectMake(47, AdmobView.frame.origin.y, 320, 50);
        
    }
    else if (Is_Ipad){
        
        AdmobView.frame = CGRectMake(20, AdmobView.frame.origin.y, 728, 90);
    }
    
}
#pragma mark - Orientation Methods
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [infoTableView reloadData];
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate{
    return NO;
}
#pragma mark - Table view methods
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
        
        
        if(section == 0){
            return [infoScreenArray count];
        }else if (section == 1){
            return [itsWorkArray count];
        }
        
    }else{
        if(section == 0){
            return [infoScreenArray count];
        }
        else if (section == 1){
            return [itsWorkArray count];
        }
        
            }
    return 0;
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
    return 35;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    UILabel *OtherHeaderTitle = [[UILabel alloc] init];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        headerView.frame=CGRectMake(0, 0, 320,30);
        OtherHeaderTitle.frame = CGRectMake(5, -5, 300, 45);
        OtherHeaderTitle.font = [UIFont systemFontOfSize:14.0f];
        
        
    }else{
        headerView.frame = CGRectMake(0, 0, 768, 50);
        OtherHeaderTitle.frame = CGRectMake(10, 10, 748, 15 );
        OtherHeaderTitle.font = [UIFont systemFontOfSize:20.0f];
        
    }
    
    NSString *titleHeader;
    switch (section){
        case 0:
            titleHeader = NSLocalizedStringFromTableInBundle(@"INFO", @"Localizable", [AppDelegate GetLocalizebundle], @"");
            break;
          
            
        case 1:
            titleHeader = NSLocalizedStringFromTableInBundle(@"PRO SERVICES", @"Localizable", [AppDelegate GetLocalizebundle], @"");
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
    InfoViewCellCustom *infoViewCellCustom = (InfoViewCellCustom *)[tableView dequeueReusableCellWithIdentifier:myIdentifire];
    
    if (infoViewCellCustom == nil){
        NSArray *nib;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            nib = [[NSBundle mainBundle] loadNibNamed:@"InfoViewCellCustom_iPhone" owner:self options:nil];
        }else{
            nib = [[NSBundle mainBundle] loadNibNamed:@"InfoViewCellCustom_iPad" owner:self options:nil];
        }
        infoViewCellCustom = (InfoViewCellCustom *)[nib objectAtIndex:0];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isfullPackPurchased"])
    {
        if(indexPath.section == 0){
            infoViewCellCustom.categoryLabel.text = NSLocalizedStringFromTableInBundle([infoScreenArray objectAtIndex:indexPath.row], @"Localizable", [AppDelegate GetLocalizebundle], @"");
            infoViewCellCustom.categoryImageView.image = [UIImage imageNamed:[infoScreenImagesArray objectAtIndex:indexPath.row]];
        }else if(indexPath.section == 1){
            infoViewCellCustom.categoryLabel.text = NSLocalizedStringFromTableInBundle([itsWorkArray objectAtIndex:indexPath.row], @"Localizable", [AppDelegate GetLocalizebundle], @"");
            infoViewCellCustom.categoryImageView.image = [UIImage imageNamed:[itsWorkImagesArray objectAtIndex:indexPath.row]];
        }
        else if(indexPath.section == 2){
            infoViewCellCustom.categoryLabel.text = NSLocalizedStringFromTableInBundle([appleHearthArray objectAtIndex:indexPath.row], @"Localizable", [AppDelegate GetLocalizebundle], @"");
            infoViewCellCustom.categoryImageView.image = [UIImage imageNamed:[appleHearthImagesArray objectAtIndex:indexPath.row]];
        }
      
    }else{
        if(indexPath.section == 0){
            infoViewCellCustom.categoryLabel.text = NSLocalizedStringFromTableInBundle([infoScreenArray objectAtIndex:indexPath.row], @"Localizable", [AppDelegate GetLocalizebundle], @"");
            infoViewCellCustom.categoryImageView.image = [UIImage imageNamed:[infoScreenImagesArray objectAtIndex:indexPath.row]];
        }
        else if(indexPath.section == 1){
            infoViewCellCustom.categoryLabel.text = NSLocalizedStringFromTableInBundle([itsWorkArray objectAtIndex:indexPath.row], @"Localizable", [AppDelegate GetLocalizebundle], @"");
            infoViewCellCustom.categoryImageView.image = [UIImage imageNamed:[itsWorkImagesArray objectAtIndex:indexPath.row]];
        }
        else if (indexPath.section == 3){
            infoViewCellCustom.backgroundColor = [UIColor clearColor];
            infoViewCellCustom.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            infoViewCellCustom.selectionStyle = UITableViewCellSelectionStyleDefault;
            
            infoViewCellCustom.categoryLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTableInBundle([ProServicesArray objectAtIndex:indexPath.row], @"Localizable",[AppDelegate GetLocalizebundle], @"")];
            infoViewCellCustom.categoryImageView.image = [UIImage imageNamed:[ProServicesArrayImages objectAtIndex:indexPath.row]];
        }
    }
    return infoViewCellCustom;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        
                if(indexPath.row == 0){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:appWebsiteURL]];
        }
        else if(indexPath.row == 1){
            intCheckView = 1;
            [self open_Mail];
        }
        else if(indexPath.row == 2){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:iTunesURL]];
        }
        else if(indexPath.row == 3){
            intCheckView = 2;
            [self open_Mail];
        }
        else if (indexPath.row == 4){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:moreAppsLinkArray]];
        }
    }
    else if(indexPath.section == 2){
        
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0)
            [self purchaseItemWithRestore:NO];
        
        else if (indexPath.row == 1)// restore
            [self purchaseItemWithRestore:YES];
    }
}
-(void)purchaseItemWithRestore:(BOOL)aBoolRestore
{
    
    if (m_InAppStore != nil)
    {
       // admobView.hidden=true;
        // Purchase object cleanup
        //        [[SKPaymentQueue defaultQueue] removeTransactionObserver:m_InAppStore];
        m_InAppStore = nil;
    }
    else
    {
        m_InAppStore = [[InAppPurchaser alloc] init];
        
        
        if (aBoolRestore)
        {
          
            [m_InAppStore restore];
            
        }
        else
        {
          // admobView.hidden=true;
            [m_InAppStore purchaseItem:unlockAd_inAppPurchaseID];
            NSLog(@"%@",unlockAd_inAppPurchaseID);
            
        }
        
    }
    
    
}
#pragma mark - Compose Mail

-(void)open_Mail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"No Mail Accounts", @"Localizable", [AppDelegate GetLocalizebundle], @"") message:NSLocalizedStringFromTableInBundle(@"Mail Account Setup Error", @"Localizable", [AppDelegate GetLocalizebundle], @"") delegate:nil cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", [AppDelegate GetLocalizebundle], @"") otherButtonTitles:nil];
            alert.tag = 1;
            [alert show];
        }
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"No Mail Accounts", @"Localizable", [AppDelegate GetLocalizebundle], @"") message:NSLocalizedStringFromTableInBundle(@"Mail Account Setup Error", @"Localizable", [AppDelegate GetLocalizebundle], @"") delegate:nil cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", [AppDelegate GetLocalizebundle], @"") otherButtonTitles:nil];
        alert.tag = 1;
        [alert show];
    }
}


-(void)displayComposerSheet
{
    NSArray *toRecipients = nil;
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    //    picker.navigationBar.tintColor = navigationThemeColor;
    picker.mailComposeDelegate = self;
    
    if(intCheckView == 1)
    {
        [picker setSubject:NSLocalizedStringFromTableInBundle(@"Feedback for App", @"Localizable", [AppDelegate GetLocalizebundle], @"")];
        toRecipients = [NSArray arrayWithObject:feedbackEmailURL];
    }
    else if(intCheckView == 2)
    {
        [picker setSubject:NSLocalizedStringFromTableInBundle(@"Check out App", @"Localizable", [AppDelegate GetLocalizebundle], @"")];
        toRecipients = [NSArray arrayWithObject:@""];
    }
    
    [picker setToRecipients:toRecipients];
    
    // Fill out the email body text
    NSString *emailBody = @"";
    
    if(intCheckView == 1)
    {
        NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
        
        NSString *ver = [[UIDevice currentDevice] systemVersion];
        float ver_float = [ver floatValue];
        NSString *deviceType = [UIDevice currentDevice].model;
        
        emailBody = [NSString stringWithFormat:@"\n\n%@: %@\n%@: %.1f\n%@: %@",NSLocalizedStringFromTableInBundle(@"App Version", @"Localizable", [AppDelegate GetLocalizebundle], @""),versionString, NSLocalizedStringFromTableInBundle(@"OS Version", @"Localizable", [AppDelegate GetLocalizebundle], @""),ver_float, NSLocalizedStringFromTableInBundle(@"Device Model", @"Localizable", [AppDelegate GetLocalizebundle], @""),deviceType];
        [picker setMessageBody:emailBody isHTML:NO];
    }
    else if(intCheckView == 2)
    {
        emailBody = NSLocalizedStringFromTableInBundle(@"Tell_A_Friend_EmailBody", @"Localizable", [AppDelegate GetLocalizebundle], @"");
        [picker setMessageBody:emailBody isHTML:YES];
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //        [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark -
#pragma mark Workaround

-(void)launchMailAppOnDevice
{
    NSString *recipients = @"";
    NSString *body = @"&body=";
    
    if(intCheckView == 1)
        body = [body stringByAppendingString:@""];
    else if(intCheckView == 2)
        body = [body stringByAppendingString:NSLocalizedStringFromTableInBundle(@"https://itunes.apple.com/app/heart-rate-monitor-instant/id990587202?ls=1&mt=8", @"Localizable", [AppDelegate GetLocalizebundle], @"")];
    
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}
@end
