//
//  HMUser.m
//  HeartMate
//
//  Created by xaoxuu on 04/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HMUser.h"

@implementation HMUser

- (instancetype)init{
    if (self = [super init]) {
        self.firstName = @"";
        self.lastName = @"";
        self.email = @"";
        self.phone = @"";
        self.birthday = [[NSDate date] dateByAddingYears:-18];
        self.avatar = @"";
        self.height = 180;
        self.weight = 65.0;
        self.joinDate = [NSDate date];
    }
    return self;
}

+ (instancetype)currentUser{
    HMUser *user = [HMUser allObjects].lastObject;
    if (!user) {
        user = [HMUser createUser];
    }
    return user;
}

+ (instancetype)createUser{
    HMUser *user = [[HMUser alloc] init];
    RLMRealm *rlm = [RLMRealm defaultRealm];
    [rlm transactionWithBlock:^{
        [rlm addObject:user];
    }];
    return user;
}


+ (NSString *)descriptionForGender:(HMGender)gender{
    switch (gender) {
        case HMGenderPrivary:
            return NSLocalizedString(@"Privary", @"");
        case HMGenderMale:
            return NSLocalizedString(@"Male", @"");
        case HMGenderFemale:
            return NSLocalizedString(@"Female", @"");
    }
}


@end
