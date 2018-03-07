//
//  HMBirthdayPicker.m
//  HeartMate
//
//  Created by xaoxuu on 06/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HMBirthdayPicker.h"
#import "HMUser.h"
@implementation HMBirthdayPicker


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.datePickerMode = UIDatePickerModeDate;
        self.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
        self.maximumDate = [NSDate date];
        self.date = [HMUser currentUser].birthday;
    }
    return self;
}

@end
