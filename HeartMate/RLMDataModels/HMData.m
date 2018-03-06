//
//  HMData.m
//  CardiotachMate
//
//  Created by xaoxuu on 04/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HMData.h"

@implementation HMData

+ (void)transactionWithBlock:(void (^)(void))block{
    RLMRealm *rlm = [RLMRealm defaultRealm];
    if (block) {
        [rlm transactionWithBlock:^{
            block();
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_USER_UPDATE object:@YES];
        }];
    }
}

- (void)transactionWithBlock:(void (^)(void))block{
    [self.class transactionWithBlock:block];
}

@end
