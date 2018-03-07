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
    
    // @xaoxuu: initialize data
    [self baseInitData];
    // @xaoxuu: initialize navigation bar
    [self baseInitNavBar];
    // @xaoxuu: initialize content view
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

- (void)baseInitData{
    if ([self respondsToSelector:@selector(ax_initProperty)]) {
        [self ax_initProperty];
    }
}

- (void)baseInitNavBar{
    // @xaoxuu: default title
    if (!self.title.length) {
        self.title = NSStringFromClass([self class]);
    }
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    } 
    
    // @xaoxuu: back bar item
    [self.navigationItem ax_hideBackBarButtonTitle];
    
    // @xaoxuu: ...
    if ([self respondsToSelector:@selector(ax_initNavigationBar)]) {
        [self ax_initNavigationBar];
    }
    
}

- (void)baseInitContentView{
    // @xaoxuu: color
    self.view.tintColor = axThemeManager.color.theme;
    self.view.backgroundColor = axThemeManager.color.background;
    // @xaoxuu: frame
    if ([self respondsToSelector:@selector(ax_contentViewFrame:)]) {
        CGRect frame = [self ax_contentViewFrame:kScreenBounds];
        self.view.frame = frame;
    } else {
        
    }
    
    // @xaoxuu: subview
    if ([self respondsToSelector:@selector(ax_initSubview)]) {
        [self ax_initSubview];
    }
    
    if ([self respondsToSelector:@selector(ax_initTableView)]) {
        [self ax_initTableView];
    }
    
    // @xaoxuu: ...
    
}




#pragma mark - delegate

- (CGRect)ax_contentViewFrame:(CGRect)frame{
    frame.origin.y = kTopBarHeight;
    frame.size.height = kScreenH - kTopBarHeight;
    return frame;
}

@end
