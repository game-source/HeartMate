//
//  BaseAnimationThread.h
//  HeartMate
//
//  Created by xaoxuu on 08/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseAnimationThread : NSObject

+ (void)performAnimation:(void (^)(void))animation;

+ (void)resumeAnimation;

@end
