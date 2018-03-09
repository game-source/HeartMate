//
//  ReminderGuideView.m
//  HeartMate
//
//  Created by xaoxuu on 09/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "ReminderGuideView.h"


@interface ReminderGuideView ()
@property (weak, nonatomic) IBOutlet UILabel *lb_tip;
@property (weak, nonatomic) IBOutlet UIImageView *icon_arrow1;
@property (weak, nonatomic) IBOutlet UIImageView *icon_arrow2;
@property (weak, nonatomic) IBOutlet UIView *iconView;

@end


@implementation ReminderGuideView



- (void)awakeFromNib{
    [super awakeFromNib];
    self.iconView.transform = CGAffineTransformMakeRotation(5*M_PI_4);
    self.tintColor = axThemeManager.color.theme;
    self.lb_tip.text = [LocalizedStringUtilities stringForGuideWithButtonDescription:NSLocalizedString(@"Plus", @"“+”") actionDescription:NSLocalizedString(@"add a reminder", @"添加一个提醒")];
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
