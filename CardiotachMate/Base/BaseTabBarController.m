//
//  BaseTabBarController.m
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tabBar.layer ax_shadow:LayerShadowUpLight];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tabBar ax_hideSeparator];
    
}

- (NSString *)classNameForBaseNavigationController{
    return @"BaseNavController";
}


@end
