//
//  HeartRateDetailChartCell.m
//  HeartMate
//
//  Created by xaoxuu on 08/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HeartRateDetailChartCell.h"

static CGFloat margin = 8.0;

@implementation HeartRateDetailChartCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupChartView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenW, 300)]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupChartView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.chartView.frame = CGRectMake(margin, margin, frame.size.width - margin * 2, frame.size.height - margin * 2);
}


- (void)setupChartView{
    self.chartView = [[AXChartView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 200)];
    self.chartView.smoothFactor = 0;
    self.chartView.backgroundColor = axThemeManager.color.theme;
    self.chartView.accentColor = axThemeManager.color.theme;
    [self addSubview:self.chartView];
}


@end
