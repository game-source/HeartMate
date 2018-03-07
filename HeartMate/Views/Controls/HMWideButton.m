//
//  HMWideButton.m
//  HeartMate
//
//  Created by xaoxuu on 07/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HMWideButton.h"

@implementation HMWideButton

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
    self.tintColor = axThemeManager.color.background;
    self.backgroundColor = axThemeManager.color.theme;
    self.titleLabel.font = axThemeManager.font.customNormal;
}

- (instancetype)initWithType:(UIButtonType)buttonType action:(void (^)(HMWideButton *))action{
    if (self = [self initWithFrame:CGRectMake(0, 0, kScreenW - 16 * 2, 50)]) {
        
        if (action) {
            [self ax_addTouchUpInsideHandler:action];
        }
    }
    return self;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType action:(void (^)(HMWideButton *))action{
    return [[self alloc] initWithType:buttonType action:action];
}




@end
