//
//  BaseAnimationThread.m
//  HeartMate
//
//  Created by xaoxuu on 08/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BaseAnimationThread.h"

static void (^block_animation)(void);


@implementation BaseAnimationThread

+ (void)performAnimation:(void (^)(void))animation{
    if (animation) {
        block_animation = animation;
        animation();
    }
}

+ (void)resumeAnimation{
    if (block_animation) {
        block_animation();
    }
}

@end
