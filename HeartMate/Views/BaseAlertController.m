//
//  BaseAlertController.m
//  HeartMate
//
//  Created by xaoxuu on 06/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BaseAlertController.h"

@interface BaseAlertController ()

@end

@implementation BaseAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle{
    BaseAlertController *vc = [super alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    vc.view.tintColor = axThemeManager.color.theme;
    return vc;
}

@end
