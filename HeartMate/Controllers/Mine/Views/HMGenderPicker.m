//
//  HMGenderPicker.m
//  HeartMate
//
//  Created by xaoxuu on 06/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HMGenderPicker.h"
#import "HMUser.h"

@interface HMGenderPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation HMGenderPicker



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dataSource = self;
        self.delegate = self;
        [self selectRow:[HMUser currentUser].gender inComponent:0 animated:YES];
    }
    return self;
}

- (void)dealloc{
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [HMUser descriptionForGender:row];
}


@end
