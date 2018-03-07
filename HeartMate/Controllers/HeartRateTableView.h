//
//  HeartRateTableView.h
//  HeartMate
//
//  Created by xaoxuu on 07/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHeartRate.h"


@interface HeartRateTableView : UITableView

/**
 按时间顺序还是倒序
 */
@property (assign, nonatomic) BOOL ascending;

@property (assign, nonatomic) BOOL showSectionHeader;


@property (strong, nonatomic) NSMutableArray<NSMutableArray<HMHeartRate *> *> *results;


- (void)reloadDataWhere:(NSString *)where ascending:(BOOL)ascending;



@end
