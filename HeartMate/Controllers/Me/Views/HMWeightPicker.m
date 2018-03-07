//
//  HMWeightPicker.m
//  HeartMate
//
//  Created by xaoxuu on 06/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HMWeightPicker.h"
#import "HMUser.h"
@interface HMWeightPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSMutableArray<NSNumber *> *values;

@end

@implementation HMWeightPicker



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dataSource = self;
        self.delegate = self;
        self.values = [NSMutableArray arrayWithCapacity:300];
        for (int i = 0; i <= 300; i++) {
            [self.values addObject:@(i+20)];
        }
        self.value = @([HMUser currentUser].weight);
    }
    return self;
}


- (NSNumber *)value{
    NSInteger row = [self selectedRowInComponent:0];
    return @(self.values[row].floatValue / 2);
}

- (void)setValue:(NSNumber *)value{
    NSInteger row = [self.values indexOfObject:@(value.floatValue * 2)];
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
        return [NSString stringWithFormat:@"%.1f %@", self.values[row].floatValue / 2, @"kg"];
    } else {
        return nil;
    }
}



@end
