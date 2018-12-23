#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>

@protocol detailViewContollerProtocol;


@class AppDelegate;
@class DatabaseManager;
@class YLProgressBar;
@class AdMobViewController;

@interface DetailViewController : UIViewController<UITextFieldDelegate>{
    AppDelegate *appDelegate;
    DatabaseManager *DBManager;
 
    IBOutlet UIView *admobView;
    AdMobViewController *adMobViewController;
}

@property (nonatomic, strong) IBOutlet YLProgressBar      *progressBarRoundedSlim;

@property (nonatomic, retain) IBOutlet UILabel *avgPulseLbl;
@property (nonatomic, readwrite) int avgPulse;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet UIButton *generalBtn;
@property (nonatomic, retain) IBOutlet UIButton *restingHRBtn;
@property (nonatomic, retain) IBOutlet UIButton *beforeSportBtn;
@property (nonatomic, retain) IBOutlet UIButton *afterSportBtn;
@property (nonatomic, retain) IBOutlet UIButton *maxHRBtn;

@property (nonatomic, retain) IBOutlet UILabel *generalLbl;
@property (nonatomic, retain) IBOutlet UILabel *restingHRLbl;
@property (nonatomic, retain) IBOutlet UILabel *beforeSportLbl;
@property (nonatomic, retain) IBOutlet UILabel *afterSportLbl;
@property (nonatomic, retain) IBOutlet UILabel *maxHRLbl;


@property (nonatomic, assign) int measurementTypeInt;

@property (nonatomic, assign) int feelType;

@property (nonatomic, retain) IBOutlet UITextField *additionalInfoTxt;

@property (nonatomic, retain) NSMutableDictionary *historyDic;
@property (nonatomic,weak,readwrite) id <detailViewContollerProtocol> delegate;

@property (weak, nonatomic) IBOutlet UITextField *weigthTextField;
@property (weak, nonatomic) IBOutlet UITextField *bloodPressureTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avgRateLabelHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avgRateLabelWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderWidth;

@property (weak, nonatomic) IBOutlet UILabel *sliderValues;

@property (weak, nonatomic) IBOutlet UITextField *blodPressureSYS;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

@property (weak, nonatomic) IBOutlet UISlider *measurementTypeSlider;

@property (nonatomic, retain) IBOutlet UILabel *measurementTypeTitleLbl;
@property (nonatomic, retain) IBOutlet UILabel *feelTypeTitleLbl;
@property (nonatomic, retain) IBOutlet UILabel *additionalInfoTitleLbl;

@property (nonatomic, retain) IBOutlet UILabel *line2Lbl;
@property (nonatomic, retain) IBOutlet UILabel *line3Lbl;

- (IBAction)sliderView:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@protocol detailViewContollerProtocol <NSObject>
@required
-(void)saveDetailCalled : (DetailViewController *)detailViewController;
@end


