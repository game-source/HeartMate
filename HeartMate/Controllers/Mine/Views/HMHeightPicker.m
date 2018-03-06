//
//  HMHeightPicker.m
//  HeartMate
//
//  Created by xaoxuu on 06/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HMHeightPicker.h"
#import "HMUser.h"
@interface HMHeightPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSMutableArray<NSNumber *> *values;

@end
@implementation HMHeightPicker



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dataSource = self;
        self.delegate = self;
        self.values = [NSMutableArray arrayWithCapacity:200];
        for (int i = 0; i <= 200; i++) {
            [self.values addObject:@(i+50)];
        }
        self.value = @([HMUser currentUser].height);
    }
    return self;
}


- (NSNumber *)value{
    NSInteger row = [self selectedRowInComponent:0];
    return self.values[row];
}

- (void)setValue:(NSNumber *)value{
    NSInteger row = [self.values indexOfObject:value];
    if (row >= self.values.count) {
        row = 0;
    }
    [self selectRow:row inComponent:0 animated:YES];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.values.count;
    } else {
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [NSString stringWithFormat:@"%@ %@", self.values[row], @"cm"];
    } else {
        return nil;
    }
}



@end
