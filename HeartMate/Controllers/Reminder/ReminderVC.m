//
//  ReminderVC.m
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "ReminderVC.h"


@interface ReminderVC ()

@end

@implementation ReminderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect)initContentFrame:(CGRect)frame{
    frame.size.height -= kTopBarHeight + kTabBarHeight;
    return frame;
}


@end
