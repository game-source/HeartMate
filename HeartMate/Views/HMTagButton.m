//
//  HMTagButton.m
//  HeartMate
//
//  Created by xaoxuu on 05/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HMTagButton.h"

@implementation HMTagButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.tintColor = axThemeManager.color.accent;
        self.imageEdgeInsets = UIEdgeInsetsMake(3, -12, 0, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setImage:UIImageNamed(@"footnote_tag") forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.titleLabel.font = axThemeManager.font.customNormal;
    }
    return self;
}

+ (instancetype)defaultButton{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, 60, 28)];
}

- (instancetype)initWithTag:(NSString *)tag delegate:(NSObject<HMTagButtonDelegate> *)delegate{
    CGSize titleSize = [tag sizeWithAttributes:@{NSFontAttributeName:axThemeManager.font.customNormal}];
    if (self = [self initWithFrame:CGRectMake(0, 0, titleSize.width + 28 + 8, 28)]) {
        [self setTitle:tag forState:UIControlStateNormal];
        self.delegate = delegate;
        __weak typeof(self) weakSelf = self;
        [self ax_addTouchUpInsideHandler:^(__kindof HMTagButton * _Nonnull sender) {
            if ([weakSelf.delegate respondsToSelector:@selector(tagButtonDidTouchUpInside:)]) {
                [weakSelf.delegate tagButtonDidTouchUpInside:sender];
            }
        }];
    }
    return self;
}

+ (instancetype)buttonWithTag:(NSString *)tag delegate:(NSObject<HMTagButtonDelegate> *)delegate{
    return [[self alloc] initWithTag:tag delegate:delegate];
}


@end
