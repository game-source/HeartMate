//
//  HeartRateDetailChartCell.h
//  HeartMate
//
//  Created by xaoxuu on 08/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXChartView.h"

@interface HeartRateDetailChartCell : UITableViewCell

/**
 chart
 */
@property (strong, nonatomic) AXChartView *chartView;

@end
