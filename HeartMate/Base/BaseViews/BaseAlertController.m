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

+ (instancetype)ax_showActionSheetWithTitle:(NSString *)title message:(NSString *)message actions:(void (^)(UIAlertController * _Nonnull))actions{
    BaseAlertController *vc = [super ax_showActionSheetWithTitle:title message:message actions:actions];
//    vc.view.tintColor = axThemeManager.color.theme;
    return vc;
}

+ (instancetype)ax_showAlertWithTitle:(NSString *)title message:(NSString *)message actions:(void (^)(UIAlertController * _Nonnull))actions{
    BaseAlertController *vc = [super ax_showAlertWithTitle:title message:message actions:actions];
//    vc.view.tintColor = axThemeManager.color.theme;
    return vc;
}
@end
