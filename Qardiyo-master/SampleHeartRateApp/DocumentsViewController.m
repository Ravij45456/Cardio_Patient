#import "DocumentsViewController.h"
#import "AppDelegate.h"
#import "DatabaseManager.h"
#import "Constants.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface DocumentsViewController ()
@end

@implementation DocumentsViewController

//@synthesize bottomView;
@synthesize delegate = _delegate;
@synthesize IndexOfLargeImage;
@synthesize Largeimage,lbl_title,lbl_one,lbl_2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
     appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    DBManager = [[DatabaseManager alloc] init];
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:@"StyleHTMLDocumentSettingsViewController" value:@"InvoiceApp"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"It work", @"Localizable", [AppDelegate GetLocalizebundle], @"");
    
    [super viewDidLoad];
            _pageImages = @[@"ImageHeartRate1.png", @"ImageHeartRate2.png"];
        IndexOfLargeImage = 0;
    Largeimage.image = [UIImage imageNamed:[_pageImages objectAtIndex:IndexOfLargeImage]];
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(NextBtn_Action:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer];
        UISwipeGestureRecognizer *recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(PreviousBtn_Action:)];
    [recognizer1 setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer1];
}
-(void)viewWillAppear:(BOOL)animated
{
    lbl_title.text = NSLocalizedStringFromTableInBundle(@"Measure", @"Localizable", [AppDelegate GetLocalizebundle], @"");
        lbl_one.text = NSLocalizedStringFromTableInBundle(@"Lightlyplace", @"Localizable", [AppDelegate GetLocalizebundle], @"");
        lbl_2.text = NSLocalizedStringFromTableInBundle(@"fullycovered", @"Localizable", [AppDelegate GetLocalizebundle], @"");
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)SideRight_Clicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
-(void)PreviousBtn_Action:(id)sender
{
    lbl_title.text = NSLocalizedStringFromTableInBundle(@"Measure", @"Localizable", [AppDelegate GetLocalizebundle], @"");
        lbl_one.text = NSLocalizedStringFromTableInBundle(@"Lightlyplace", @"Localizable", [AppDelegate GetLocalizebundle], @"");
            lbl_2.text = NSLocalizedStringFromTableInBundle(@"fullycovered", @"Localizable", [AppDelegate GetLocalizebundle], @"");
    
    if (IndexOfLargeImage == 0)
    {
            }
    else if (IndexOfLargeImage <= _pageImages.count-1) {
          IndexOfLargeImage--;
        Largeimage.image = [UIImage imageNamed:[_pageImages objectAtIndex:IndexOfLargeImage]];
    }
}
-(void)NextBtn_Action:(id)sender
{
    lbl_title.text = NSLocalizedStringFromTableInBundle(@"History", @"Localizable", [AppDelegate GetLocalizebundle], @"");
    
    lbl_one.text = NSLocalizedStringFromTableInBundle(@"pastmeasurements", @"Localizable", [AppDelegate GetLocalizebundle], @"");
    
      lbl_2.text = NSLocalizedStringFromTableInBundle(@"historyofmeasurement", @"Localizable", [AppDelegate GetLocalizebundle], @"");
    
    if (_pageImages.count-1 > IndexOfLargeImage)
    {
        IndexOfLargeImage++;
        Largeimage.image = [UIImage imageNamed:[_pageImages objectAtIndex:IndexOfLargeImage]];
    }
}

@end
