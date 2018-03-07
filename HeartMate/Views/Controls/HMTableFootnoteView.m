//
//  HMTableFootnoteView.m
//  HeartMate
//
//  Created by xaoxuu on 06/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HMTableFootnoteView.h"

@interface HMTableFootnoteView ()

@property (strong, nonatomic) UIButton *btn;
@property (strong, nonatomic) CALayer *line;

@end

@implementation HMTableFootnoteView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.tintColor = [UIColor clearColor];
        CALayer *line = [CALayer layer];
        [self.layer addSublayer:line];
        [self setFrame:frame];
        self.line.backgroundColor = axThemeManager.color.background.darkRatio(0.2).CGColor;
        self.line = line;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    self.line.frame = CGRectMake(0, 0.5*height, width, 0.5);
}

+ (instancetype)viewWithTitle:(NSString *)title{
    HMTableFootnoteView *view = [[self alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    [btn setTitle:title forState:UIControlStateNormal];
    [view addSubview:btn];
    
    
    
    return view;
}



@end
