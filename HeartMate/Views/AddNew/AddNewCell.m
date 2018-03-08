//
//  AddNewCell.m
//  HeartMate
//
//  Created by xaoxuu on 08/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "AddNewCell.h"
#import "HMWideButton.h"

static CGFloat buttonSize = 50;

@interface AddNewCell ()

@property (strong, nonatomic) UIButton *button;

@end


@implementation AddNewCell

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

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    self.button.center = CGPointMake(0.5*frame.size.width, 0.5*frame.size.height);
    
}

- (void)_init{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    __weak typeof(self) weakSelf = self;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonSize, buttonSize)];
    [button.layer ax_cornerRadius:8 shadow:LayerShadowNone];
    button.tintColor = axThemeManager.color.theme;
//    button.backgroundColor = axThemeManager.color.theme;
    [button ax_addTouchUpInsideHandler:^(__kindof UIButton * _Nonnull sender) {
        if (weakSelf.block_tapped) {
            weakSelf.block_tapped();
        }
    }];
    [button setImage:UIImageNamed(@"tabbar_add") forState:UIControlStateNormal];
    self.button = button;
    [self addSubview:button];
    
    
}


@end
