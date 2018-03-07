//
//  HeartRateTableViewCell.h
//  HeartMate
//
//  Created by xaoxuu on 05/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHeartRate.h"


@interface HeartRateTableViewCell : UITableViewCell

/**
 model
 */
@property (strong, nonatomic) HMHeartRate *model;

@end
