//
//  GuideView.m
//  HeartMate
//
//  Created by xaoxuu on 08/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "GuideView.h"


@interface GuideView ()
@property (weak, nonatomic) IBOutlet UILabel *lb_tip;
@property (weak, nonatomic) IBOutlet UIImageView *icon_arrow1;
@property (weak, nonatomic) IBOutlet UIImageView *icon_arrow2;

@end


@implementation GuideView


- (void)awakeFromNib{
    [super awakeFromNib];
    self.tintColor = axThemeManager.color.theme;
    self.lb_tip.text = NSLocalizedString(@"Touch the Record button to start measuring heart rate.", @"轻触“Record”按钮开始测量心率。");
    [self startAnimation];
}

- (void)startAnimation{
    [BaseAnimationThread performAnimation:^{
        self.icon_arrow1.alpha = 0;
        self.icon_arrow2.alpha = 0;
        [UIView animateWithDuration:1.8 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionCurveEaseIn animations:^{
            self.icon_arrow2.alpha = 1;
            self.icon_arrow2.transform = CGAffineTransformMakeTranslation(0, 24);
        } completion:^(BOOL finished) {
            self.icon_arrow2.alpha = 0;
            self.icon_arrow2.transform = CGAffineTransformIdentity;
        }];
        [UIView animateWithDuration:1.8 delay:0.08 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionCurveEaseOut animations:^{
            self.icon_arrow1.alpha = 1;
            self.icon_arrow1.transform = CGAffineTransformMakeTranslation(0, 24);
        } completion:^(BOOL finished) {
            self.icon_arrow1.alpha = 0;
            self.icon_arrow1.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)stopAnimation{
    [self.icon_arrow1.layer removeAllAnimations];
    [self.icon_arrow2.layer removeAllAnimations];
}

@end
