#import <UIKit/UIKit.h>
#import "BarChartView.h"

@class HistoryTableViewCell;
@class DetailViewController;
@class AppDelegate;
@class DatabaseManager;
@class AdMobViewController;

@interface HistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    DetailViewController *detailViewController;
    AppDelegate *appDelegate;
    DatabaseManager *DBManager;
    
    IBOutlet UIView *admobView;
    AdMobViewController *adMobViewController;
}
- (BOOL)isDeviceAniPhone4;

@property (weak, nonatomic) IBOutlet UILabel *lbl_avg;

@property (weak, nonatomic) IBOutlet UILabel *lbl_10Mesurment;

@property (nonatomic, retain) IBOutlet UITableView *tbl;
@property (nonatomic, retain) NSMutableArray *sortedDB_Arr;

@property (strong, nonatomic) IBOutlet BarChartView *barChart;
@property (nonatomic, retain) NSMutableArray *barChartValue_Arr;
@property (nonatomic, retain) NSMutableArray *barChartValueColor_Arr;

@property (nonatomic, retain) IBOutlet UILabel *avgPulseLine;
@property (nonatomic, retain) IBOutlet UILabel *avgPulseTxtLbl;
@property (nonatomic, retain) IBOutlet UILabel *avgPulseValueLbl;
@end
