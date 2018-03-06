//
//  ReminderTVC.m
//  HeartMate
//
//  Created by xaoxuu on 06/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "ReminderTVC.h"
#import "HMTagButton.h"

@interface ReminderTVC () <HMTagButtonDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UIImageView *imgv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *content;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;


@end



@implementation ReminderTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tintColor = axThemeManager.color.theme;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HMReminder *)model{
    _model = model;
    
    self.lb_title.text = model.title;
    
    [self.content removeAllSubviews];
    if (model.weekday.count) {
        NSArray<NSString *> *weekday = model.descriptionForWeekday;
        CGFloat lastX = 0;
        for (int i = 0; i < weekday.count; i++) {
            HMTagButton *btn = [HMTagButton buttonWithTag:weekday[i] delegate:self];
            [btn setImage:UIImageNamed(@"footnote_ring") forState:UIControlStateNormal];
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
    AXLogOBJ(log);
}

@end
