#import <UIKit/UIKit.h>

@class AppDelegate;
@class DatabaseManager;

@interface DocumentsViewController : UIViewController<UIGestureRecognizerDelegate>{
    AppDelegate *appDelegate;
    DatabaseManager *DBManager;
}
@property(nonatomic, assign) AppDelegate *delegate;
//@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@property (nonatomic ,readwrite) int IndexOfLargeImage;
@property (nonatomic, readwrite) IBOutlet UIImageView *Largeimage;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_one;
@property (weak, nonatomic) IBOutlet UILabel *lbl_2;

@end
