//
//  HMWideButton.h
//  HeartMate
//
//  Created by xaoxuu on 07/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMWideButton : UIButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType action:(void (^)(HMWideButton *sender))action;

@end
