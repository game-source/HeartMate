//
//  TimelineTVC.m
//  HeartMate
//
//  Created by xaoxuu on 05/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "TimelineTVC.h"
#import "HMTagButton.h"


@interface TimelineTVC () <HMTagButtonDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lb_hr;
@property (weak, nonatomic) IBOutlet UIImageView *imgv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *content;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;


@end


@implementation TimelineTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tintColor = axThemeManager.color.theme;
    self.lb_hr.textColor = self.tintColor;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)_init{
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setModel:(HMHeartRate *)model{
    _model = model;
    
    self.lb_hr.text = NSStringFromNSInteger(model.heartRate);
    
    [self.content removeAllSubviews];
    if (model.tags.count) {
        CGFloat lastX = 0;
        for (int i = 0; i < model.tags.count; i++) {
            NSString *tag = model.tags[i];
            HMTagButton *btn = [HMTagButton buttonWithTag:tag delegate:self];
            [btn setTintColor:axThemeManager.color.accent];
            btn.left = lastX;
            lastX += btn.width;
            self.contentWidth.constant = lastX;
            [self.content addSubview:btn];
        }
    }
    
    
}


- (void)tagButtonDidTouchUpInside:(HMTagButton *)sender{
    NSString *log = [NSString stringWithFormat:@"点击了Tag<%@>", sender.titleLabel.text];
    AXCachedLogOBJ(log);
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.alpha = 0;
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
    } completion:nil];
}

@end
