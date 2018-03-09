//
//  InputTableViewCell.m
//  HeartMate
//
//  Created by xaoxuu on 09/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "InputTableViewCell.h"

static CGFloat marginX = 16;
static CGFloat marginY = 4;
static CGFloat lbHeight = 28;
static CGFloat tfHeight = 44;

@interface InputTableViewCell ()

@property (strong, nonatomic) UILabel *lb_title;

@property (strong, nonatomic) BaseTextField *tf_input;

@end


@implementation InputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)rowHeight{
    return 3*marginY + lbHeight + tfHeight;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _init];
    }
    return self;
}


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];

    [self.lb_title sizeToFit];
    
}

- (void)_init{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat width = kScreenW - 2 * marginX;
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(marginX, marginY, width, lbHeight)];
    self.lb_title = lb;
    [self addSubview:lb];
    lb.font = axThemeManager.font.customNormal;
    lb.text = @"Please input new text";
    lb.textColor = [UIColor grayColor];
    
    BaseTextField *tf = [[BaseTextField alloc] initWithFrame:CGRectMake(marginX, lb.bottom + marginY, width, tfHeight)];
    self.tf_input = tf;
    tf.returnKeyType = UIReturnKeyDone;
    
    [self addSubview:tf];
    
    
    
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.lb_title.text = title;
}

- (void)setText:(NSString *)text{
    _text = text;
    self.tf_input.text = text;
}

- (void)setDelegate:(NSObject<InputTableViewCellDelegate> *)delegate{
    _delegate = delegate;
    __weak typeof(self) weakSelf = self;
    [self.tf_input ax_addEditingChangedHandler:^(__kindof UITextField * _Nonnull sender) {
        if ([weakSelf.delegate respondsToSelector:@selector(inputCell:didEditingChanged:)]) {
            [weakSelf.delegate inputCell:weakSelf didEditingChanged:sender.text];
        }
    }];
    [self.tf_input ax_addEditingEndOnExitHandler:^(__kindof UITextField * _Nonnull sender) {
        if ([weakSelf.delegate respondsToSelector:@selector(inputCell:didEditingEndOnExit:)]) {
            [weakSelf.delegate inputCell:weakSelf didEditingEndOnExit:sender.text];
        }
    }];
}

- (BOOL)becomeFirstResponder{
    return [self.tf_input becomeFirstResponder];
}

- (BOOL)resignFirstResponder{
    return [self.tf_input resignFirstResponder];
}

@end
