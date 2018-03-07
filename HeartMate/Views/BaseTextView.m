//
//  BaseTextView.m
//  HeartMate
//
//  Created by xaoxuu on 07/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BaseTextView.h"

@implementation BaseTextView


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
    [self.layer ax_borderWidth:1 color:axThemeManager.color.background.darkRatio(0.2)];
    __weak typeof(self) weakSelf = self;
//
//    [self ax_addEditingBeginHandler:^(__kindof UITextField * _Nonnull sender) {
//        [weakSelf.layer ax_borderWidth:1 color:axThemeManager.color.theme];
//    }];
//    [self ax_addEditingEndHandler:^(__kindof UITextField * _Nonnull sender) {
//        [weakSelf.layer ax_borderWidth:1 color:axThemeManager.color.background.dark];
//    }];
}


@end
