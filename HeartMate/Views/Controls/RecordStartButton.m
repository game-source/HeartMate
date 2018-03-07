//
//  RecordStartButton.m
//  HeartMate
//
//  Created by xaoxuu on 07/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "RecordStartButton.h"

@implementation RecordStartButton

/*
UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
[self.view addSubview:button];
self.button = button;
button.titleLabel.font = [UIFont fontWithName:axThemeManager.font.name size:17];
button.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
[button.layer ax_whiteBorder:1.2];
[button.layer ax_cornerRadius:0.5*button.height shadow:LayerShadowNone];
button.bottom = height - 20 - kTabBarHeight;
button.centerX = centerX;
[button setTitle:NSLocalizedString(@"Start", @"结束测量") forState:UIControlStateNormal];
[button setTitle:NSLocalizedString(@"Stop", @"结束测量") forState:UIControlStateSelected];
__weak typeof(self) weakSelf = self;
[button ax_addTouchUpInsideHandler:^(__kindof UIButton * _Nonnull sender) {
    if (sender.selected) {
        [sender ax_animatedScale:0.7 duration:1.8 completion:nil];
        [weakSelf stopCapture];
    } else {
        [sender ax_animatedScale:1.15 duration:1.5 completion:nil];
        [weakSelf startCapture];
    }
}];

*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.tintColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        self.titleLabel.font = axThemeManager.font.customLarge;
        [self.layer ax_whiteBorder:1.2];
        [self.layer ax_maskToCircle];
        [self setTitle:NSLocalizedString(@"Start", @"结束测量") forState:UIControlStateNormal];
        [self setTitle:NSLocalizedString(@"Stop", @"结束测量") forState:UIControlStateSelected];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self ax_animatedScale:1.15 duration:1.0 completion:nil];
    } else {
        [self ax_animatedScale:0.5 duration:1.6 completion:nil];
    }
}

@end
