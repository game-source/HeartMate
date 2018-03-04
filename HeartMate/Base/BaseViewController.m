//
//  BaseViewController.m
//  AXKit
//
//  Created by xaoxuu on 29/04/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // @xaoxuu: 基类 初始化 顶部区域 NavigationBar
    [self baseInitNavBar];
    // @xaoxuu: 基类 初始化 内容区域
    [self baseInitContentView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)dealloc{
    AXLogSuccess(@"%@ deallocated", NSStringFromClass([self class]));
}

- (BOOL)hidesBottomBarWhenPushed{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    } else {
        return YES;
    }
}


#pragma mark - base init
// @xaoxuu: 基类 初始化 顶部区域 NavigationBar
- (void)baseInitNavBar{
    // @xaoxuu: default title
    if (!self.title.length) {
        self.title = NSStringFromClass([self class]);
    }
    
    // @xaoxuu: back bar item
    [self.navigationItem ax_hideBackBarButtonTitle];
    // @xaoxuu: ...
    
}

// @xaoxuu: 基类 初始化 内容区域
- (void)baseInitContentView{
    // @xaoxuu: color
    self.view.backgroundColor = axThemeManager.color.background;
    // @xaoxuu: frame
    self.view.frame = kScreenBounds;
    if ([self respondsToSelector:@selector(initContentFrame:)]) {
        self.view.frame = [self initContentFrame:self.view.frame];
    }
    
    if ([self respondsToSelector:@selector(initContentView:)]) {
        [self initContentView:self.view];
    }
    
    // @xaoxuu: subview
    if ([self respondsToSelector:@selector(initSubview)]) {
        [self initSubview];
    }
    
    
    // @xaoxuu: ...
    
}




#pragma mark - delegate

- (CGRect)initContentFrame:(CGRect)frame{
    frame.origin.y = kTopBarHeight;
    frame.size.height = kScreenH - kTopBarHeight;
    return frame;
}

@end
