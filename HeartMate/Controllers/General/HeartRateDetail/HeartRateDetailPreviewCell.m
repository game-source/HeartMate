//
//  HeartRateDetailPreviewCell.m
//  HeartMate
//
//  Created by xaoxuu on 08/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HeartRateDetailPreviewCell.h"


@interface HeartRateDetailPreviewCell ()

/**
 hr
 */
@property (strong, nonatomic) UILabel *lb_hr;
@property (strong, nonatomic) UILabel *lb_bpm;

@end


@implementation HeartRateDetailPreviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _init];
    }
    return self;
}

- (void)setHeartRate:(NSInteger)heartRate{
    _heartRate = heartRate;
    self.lb_hr.text = NSStringFromNSInteger(heartRate);
    
    
    CGSize selfSize = self.bounds.size;
    
    
    [self.lb_hr sizeToFit];
    self.lb_hr.height = selfSize.height;
    self.lb_bpm.left = self.lb_hr.right + 8;
    self.lb_bpm.bottom = self.lb_hr.bottom - 4;
    
    
}


- (void)_init{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, kScreenW - 16*2, 40)];
    self.lb_hr = lb;
    [self addSubview:lb];
    lb.font = [UIFont fontWithName:axThemeManager.font.name size:54];
    lb.text = @"68";
    lb.textColor = axThemeManager.color.theme;
    
    UILabel *bpm = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    self.lb_bpm = bpm;
    [self addSubview:bpm];
    bpm.text = @"bpm";
    bpm.font = axThemeManager.font.customLarge;
    bpm.textColor = [UIColor darkGrayColor];
    bpm.left = lb.right;
    [bpm sizeToFit];
}

@end
