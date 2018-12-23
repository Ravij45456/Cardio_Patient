//
//  HistoryTableViewCell.h
//  SampleHeartRateApp
//
//  Created by Gaurav Mehta on 14/04/15.
//  Copyright (c) 2015 CMG Research Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *typeImgView;
@property (nonatomic, retain) IBOutlet UILabel *titleLbl;
@property (nonatomic, retain) IBOutlet UILabel *dateLbl;
@property (nonatomic, retain) IBOutlet UILabel *avgLbl;

@end
