//
//  HeartRateDetailTV.h
//  HeartMate
//
//  Created by xaoxuu on 08/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <AXKit/AXKit.h>
#import "HMHeartRate.h"

@interface HeartRateDetailTV : AXTableView

/**
 model
 */
@property (strong, nonatomic) HMHeartRate *model;

@end
