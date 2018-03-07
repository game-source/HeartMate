//
//  BaseTextField.m
//  HeartMate
//
//  Created by xaoxuu on 07/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField



- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self _init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (void)_init{
    [self.layer ax_cornerRadius:8 shadow:LayerShadowNone];
    self.tintColor = axThemeManager.color.theme;
    self.backgroundColor = [UIColor whiteColor];
    [self.layer ax_borderWidth:1 color:[UIColor clearColor]];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 1)];
    leftView.backgroundColor = self.backgroundColor;
    leftView.userInteractionEnabled = NO;
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 1)];
    rightView.backgroundColor = self.backgroundColor;
    rightView.userInteractionEnabled = NO;
    self.rightView = rightView;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    __weak typeof(self) weakSelf = self;
    [self ax_addEditingBeginHandler:^(__kindof UITextField * _Nonnull sender) {
        [weakSelf.layer ax_borderWidth:1 color:axThemeManager.color.theme];
    }];
    [self ax_addEditingEndHandler:^(__kindof UITextField * _Nonnull sender) {
        [weakSelf.layer ax_borderWidth:1 color:[UIColor clearColor]];
    }];
}



@end
