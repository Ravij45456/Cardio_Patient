#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

@synthesize typeImgView, titleLbl, dateLbl, avgLbl;

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
