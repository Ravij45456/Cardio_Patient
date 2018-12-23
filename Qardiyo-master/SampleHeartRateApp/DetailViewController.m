#import "DetailViewController.h"
#import "YLProgressBar.h"
#import "QardiyoHF-Swift.h"
#include <sys/utsname.h>

// Displayed AFTER the pulse is taken.

@interface DetailViewController ()
{
    
}
@end

@implementation DetailViewController

@synthesize generalBtn, restingHRBtn, beforeSportBtn, afterSportBtn, maxHRBtn;
@synthesize generalLbl, restingHRLbl, beforeSportLbl, afterSportLbl, maxHRLbl;
@synthesize measurementTypeInt, feelType;
@synthesize additionalInfoTxt;
@synthesize avgPulse;
@synthesize scrollView;
@synthesize avgPulseLbl;
@synthesize historyDic;

//@synthesize FeelType1Btn, FeelType2Btn, FeelType3Btn, FeelType4Btn, FeelType5Btn;

@synthesize measurementTypeTitleLbl, feelTypeTitleLbl, additionalInfoTitleLbl;
@synthesize line2Lbl, line3Lbl;


- (void)viewDidLoad {
    
    self.hideKeyboardWhenTappedAround;
    
    //This code below will get the device type being used
    struct utsname systemInfo;
    uname(&systemInfo);
//    NSString *modelName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",modelName);
  
//    if([modelName isEqualToString:@"iPhone6,1"]){
      _textViewHeight.constant = 60;
      _stackViewHeight.constant = 60;
      _sliderWidth.constant = 290;
      [_measurementTypeSlider updateConstraints];
      [_sliderValues setFont:[_sliderValues.font fontWithSize:14]];
//    }
  
  
    NSUserDefaults *userD =[NSUserDefaults standardUserDefaults];
    [userD setValue:@"No" forKey:@"General"];
    [userD setValue:@"No" forKey:@"Resting"];
    [userD setValue:@"No" forKey:@"PreExercise"];
    [userD setValue:@"No" forKey:@"PostExercise"];
    [userD setValue:@"No" forKey:@"MaxHeartRate"];
  
    [userD setValue:@"No" forKey:@"Excited"];
    [userD setValue:@"No" forKey:@"Happy"];
    [userD setValue:@"No" forKey:@"Bland"];
    [userD setValue:@"No" forKey:@"Sad"];
    [userD setValue:@"No" forKey:@"Angry"];
  
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed: 25.0/255.0 green: 63.0/255.0 blue: 76.0/255.0 alpha:1.0];
    
    self.title = @"Detail View Controller Title";

    generalLbl.textColor =[UIColor colorWithRed:123/255.0 green:171/255.0 blue:56/255.0 alpha:1];
    
    beforeSportLbl.textColor =[UIColor colorWithRed:123/255.0 green:171/255.0 blue:56/255.0 alpha:1];
    
    afterSportLbl.textColor =[UIColor colorWithRed:123/255.0 green:171/255.0 blue:56/255.0 alpha:1];
    
    restingHRLbl.textColor =[UIColor colorWithRed:123/255.0 green:171/255.0 blue:56/255.0 alpha:1];
    
    maxHRLbl.textColor =[UIColor colorWithRed:123/255.0 green:171/255.0 blue:56/255.0 alpha:1];
    
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
    
    [admobView setHidden:TRUE];
    [admobView removeFromSuperview];
  
  
//    [generalBtn setSelected:NO];
//    [restingHRBtn setSelected:NO];
//    [beforeSportBtn setSelected:NO];
//    [afterSportBtn setSelected:NO];
//    [maxHRBtn setSelected:NO];
//
  
    // Displays current time/date ontop of the navigation controller.
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSString *displayDate = [dateFormatter stringFromDate:[NSDate date]];
    self.navigationItem.title = displayDate;
    
    self.navigationItem.titleView.backgroundColor = [UIColor redColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(DiscardBtn_Action)];
 
    // This sets the Discard button color.
    left.tintColor = [UIColor colorWithRed:142.0/255.0 green:184.0/255.0 blue:72.0/255.0 alpha:1.0];
    left.title = @"Discard";
    
    // Putting the discard button on to the screen, on the left spot.
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(SaveBtn_Action)];
  
    
    right.tintColor =[UIColor colorWithRed:142.0/255.0 green:184.0/255.0 blue:72.0/255.0 alpha:1.0];
    right.title = @"Save";
    
    
    self.navigationItem.rightBarButtonItem = right;
    
    additionalInfoTxt.delegate = self;
  
     avgPulseLbl.text=@"456";
    if (avgPulse < 10) {
        avgPulseLbl.text = [NSString stringWithFormat:@"00%d",avgPulse];
    }else if (avgPulse < 100) {
        avgPulseLbl.text = [NSString stringWithFormat:@"0%d",avgPulse];
    }else{
        avgPulseLbl.text = [NSString stringWithFormat:@"%d",avgPulse];
        
    }

    [self initRoundedSlimProgressBar];
}
-(void)viewWillAppear:(BOOL)animated
{
    avgPulseLbl.text = [NSString stringWithFormat:@"%d",avgPulse];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    [d setValue:@"yes" forKey:@"automaticLightON"];
    [d synchronize];

}


#pragma mark - YLViewController Private Methods
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    [_progressBarRoundedSlim setProgress:progress animated:animated];
}

- (void)initRoundedSlimProgressBar{
//    _progressBarRoundedSlim.type               = YLProgressBarTypeRounded;
//    _progressBarRoundedSlim.progressTintColor  = [UIColor blueColor];
//    _progressBarRoundedSlim.hideStripes        = YES;
//    
//    // Green rounded/gloss progress, with vertical animated stripes in the left direction
//    _progressBarRoundedSlim.type               = YLProgressBarTypeRounded;
//    _progressBarRoundedSlim.progressTintColor  = [UIColor greenColor];
//    _progressBarRoundedSlim.stripesOrientation = YLProgressBarStripesOrientationVertical;
//    _progressBarRoundedSlim.stripesDirection   = YLProgressBarStripesDirectionLeft;
  
    NSArray *rainbowColors=@[[UIColor colorWithRed:123.0/255.0 green:171.0/255.0 blue:56.0/255.0 alpha:1]];
    
    _progressBarRoundedSlim.type                     = YLProgressBarTypeRounded;
    _progressBarRoundedSlim.hideStripes              = YES;
    //_progressBarRoundedSlim.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeProgress;
    _progressBarRoundedSlim.progressTintColors       = rainbowColors;
    float countAvgPulse = ((float)avgPulse/100);
    [self setProgress:countAvgPulse animated:YES];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Measurement Type
-(IBAction)General_Action:(id)sender{
  
    NSUserDefaults *userD =[NSUserDefaults standardUserDefaults];
    NSString *pressed = [userD objectForKey:@"General"];
    if ([pressed isEqualToString:@"No"])   {
      [userD setValue:@"Yes" forKey:@"General"];
      [userD setValue:@"No" forKey:@"PostExercise"];
      [userD setValue:@"No" forKey:@"MaxHeartRate"];
      [userD setValue:@"No" forKey:@"PreExercise"];
      [userD setValue:@"No" forKey:@"Resting"];
      [restingHRBtn setBackgroundColor:[UIColor clearColor]];
      [beforeSportBtn setBackgroundColor:[UIColor clearColor]];
      [afterSportBtn setBackgroundColor:[UIColor clearColor]];
      [maxHRBtn setBackgroundColor:[UIColor clearColor]];
      [generalBtn setBackgroundColor:[UIColor colorWithRed:123/255.0 green:171/255.0 blue:56/255.0 alpha:1.0]];
    }
    if ([pressed isEqualToString:@"Yes"]){
      [userD setValue:@"No" forKey:@"General"];
      [generalBtn setSelected:NO];
      [generalBtn setBackgroundColor:[UIColor clearColor]];
    }
  
    generalBtn.layer.cornerRadius = 21;
  
}

-(IBAction)RestingHR_Action:(id)sender{
  
    NSUserDefaults *userD =[NSUserDefaults standardUserDefaults];
    NSString *pressed = [userD objectForKey:@"Resting"];
    if ([pressed isEqualToString:@"No"])   {
      [userD setValue:@"Yes" forKey:@"Resting"];
      [userD setValue:@"No" forKey:@"PostExercise"];
      [userD setValue:@"No" forKey:@"MaxHeartRate"];
      [userD setValue:@"No" forKey:@"PreExercise"];
      [userD setValue:@"No" forKey:@"General"];
      [generalBtn setBackgroundColor:[UIColor clearColor]];
      [beforeSportBtn setBackgroundColor:[UIColor clearColor]];
      [afterSportBtn setBackgroundColor:[UIColor clearColor]];
      [maxHRBtn setBackgroundColor:[UIColor clearColor]];
      [restingHRBtn setBackgroundColor:[UIColor colorWithRed:123/255.0 green:171/255.0 blue:56/255.0 alpha:1.0]];
    }
    if ([pressed isEqualToString:@"Yes"]){
      [userD setValue:@"No" forKey:@"Resting"];
      [restingHRBtn setSelected:NO];
      [restingHRBtn setBackgroundColor:[UIColor clearColor]];
    }
  
    restingHRBtn.layer.cornerRadius = 21;
  
}

-(IBAction)BeforeSport_Action:(id)sender{
  
    NSUserDefaults *userD =[NSUserDefaults standardUserDefaults];
    NSString *pressed = [userD objectForKey:@"PreExercise"];
    if ([pressed isEqualToString:@"No"])   {
      [userD setValue:@"Yes" forKey:@"PreExercise"];
      [userD setValue:@"No" forKey:@"PostExercise"];
      [userD setValue:@"No" forKey:@"MaxHeartRate"];
      [userD setValue:@"No" forKey:@"Resting"];
      [userD setValue:@"No" forKey:@"General"];
      [generalBtn setBackgroundColor:[UIColor clearColor]];
      [restingHRBtn setBackgroundColor:[UIColor clearColor]];
      [afterSportBtn setBackgroundColor:[UIColor clearColor]];
      [maxHRBtn setBackgroundColor:[UIColor clearColor]];
      [beforeSportBtn setBackgroundColor:[UIColor colorWithRed:123/255.0 green:171/255.0 blue:56/255.0 alpha:1.0]];
    }
    if ([pressed isEqualToString:@"Yes"]){
      [userD setValue:@"No" forKey:@"PreExercise"];
      [beforeSportBtn setSelected:NO];
      [beforeSportBtn setBackgroundColor:[UIColor clearColor]];
    }
  
    beforeSportBtn.layer.cornerRadius = 21;
}

-(IBAction)AfterSport_Action:(id)sender{
  
     NSUserDefaults *userD =[NSUserDefaults standardUserDefaults];
    NSString *pressed = [userD objectForKey:@"PostExercise"];
    if ([pressed isEqualToString:@"No"])   {
      [userD setValue:@"Yes" forKey:@"PostExercise"];
      [userD setValue:@"No" forKey:@"MaxHeartRate"];
      [userD setValue:@"No" forKey:@"PreExercise"];
      [userD setValue:@"No" forKey:@"Resting"];
      [userD setValue:@"No" forKey:@"General"];

      [generalBtn setBackgroundColor:[UIColor clearColor]];
      [beforeSportBtn setBackgroundColor:[UIColor clearColor]];
      [restingHRBtn setBackgroundColor:[UIColor clearColor]];
      [maxHRBtn setBackgroundColor:[UIColor clearColor]];
      [afterSportBtn setBackgroundColor:[UIColor colorWithRed:123/255.0 green:171/255.0 blue:56/255.0 alpha:1.0]];
    }
    if ([pressed isEqualToString:@"Yes"]){
      [userD setValue:@"No" forKey:@"PostExercise"];
      [afterSportBtn setSelected:NO];
      [afterSportBtn setBackgroundColor:[UIColor clearColor]];
    }
  
    afterSportBtn.layer.cornerRadius = 21;
}


-(IBAction)MaxHR_Action:(id)sender{
  
    NSUserDefaults *userD =[NSUserDefaults standardUserDefaults];
    NSString *pressed = [userD objectForKey:@"MaxHeartRate"];
    if ([pressed isEqualToString:@"No"])   {
      [userD setValue:@"Yes" forKey:@"MaxHeartRate"];
      [userD setValue:@"No" forKey:@"PostExercise"];
      [userD setValue:@"No" forKey:@"PreExercise"];
      [userD setValue:@"No" forKey:@"Resting"];
      [userD setValue:@"No" forKey:@"General"];
      [generalBtn setBackgroundColor:[UIColor clearColor]];
      [beforeSportBtn setBackgroundColor:[UIColor clearColor]];
      [afterSportBtn setBackgroundColor:[UIColor clearColor]];
      [restingHRBtn setBackgroundColor:[UIColor clearColor]];
      [maxHRBtn setBackgroundColor:[UIColor colorWithRed:123/255.0 green:171/255.0 blue:56/255.0 alpha:1.0]];
    }
    if ([pressed isEqualToString:@"Yes"]){
      [userD setValue:@"No" forKey:@"MaxHeartRate"];
      [maxHRBtn setSelected:NO];
      [maxHRBtn setBackgroundColor:[UIColor clearColor]];
    }
  
    maxHRBtn.layer.cornerRadius = 21;
}


#pragma mark - UITextField Delegate
-(void)DiscardBtn_Action
{
    //Dismiss to HomeViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *tabViewController;
    tabViewController = [storyboard instantiateViewControllerWithIdentifier:@"goToTabBar"];
    [self presentViewController:tabViewController animated:true completion:nil];
}

// Here are all the actions that take place after tapping save button. For now it dismisses VC.
-(void)SaveBtn_Action{
  
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMM d, h:mm a"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    [d setValue:[NSString stringWithFormat:@"%d",avgPulse] forKey:@"avgPulse"];
    [d setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"dateTime"];
    [d setValue:_weigthTextField.text forKey:@"weigth"];
    [d setValue:_bloodPressureTextField.text forKey:@"bpDIA"];
    [d setValue:_blodPressureSYS.text forKey:@"bpSYS"];
    [d setValue:_textView.text forKey:@"additionalInfo"];
    [d setValue:[NSString stringWithFormat:@"%f", _measurementTypeSlider.value] forKey:@"mood"];
    [d synchronize];
  
    //dismiss to HomeViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *tabViewController;
    tabViewController = [storyboard instantiateViewControllerWithIdentifier:@"goToTabBar"];

    [self presentViewController:tabViewController animated:true completion:nil];
}

- (IBAction)sliderView:(id)sender {
    _slider.value = roundf(_slider.value);
}
@end
