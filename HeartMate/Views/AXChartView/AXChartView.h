//
//  AXChartView.h
//  AXChartView
//
//  Created by xaoxuu on 14/09/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AXChartView;
/**
 图表的数据源
 */
@protocol AXChartViewDataSource <NSObject>

/**
 总列数
 
 @return 总列数
 */
- (NSInteger)chartViewItemsCount:(AXChartView *)chartView;


/**
 第index列的值
 
 @param index 列索引
 @return 第index列的值
 */
- (NSNumber *)chartView:(AXChartView *)chartView valueForIndex:(NSInteger)index;


/**
 第index列的标题
 
 @param index 列索引
 @return 第index列的标题
 */
- (NSString *)chartView:(AXChartView *)chartView titleForIndex:(NSInteger)index;

@optional


/**
 右上角的摘要文本（默认为数据总和）

 @param label 标签，可自定义此控件
 @return 右上角的摘要文本（默认为数据总和）
 */
- (NSString *)chartView:(AXChartView *)chartView summaryText:(UILabel *)label;


/**
 当item过多时无法全部显示出来，需要决定每几个显示一个

 @return 当item过多时无法全部显示出来，需要决定每几个显示一个
 */
- (NSInteger)chartViewShowTitleForIndexWithSteps:(AXChartView *)chartView;

/**
 最大值（如果实际值有超过此值的，按照实际的最大值计算）

 @return 最大值（如果实际值有超过此值的，按照实际的最大值计算）
 */
- (NSNumber *)chartViewMaxValue:(AXChartView *)chartView;


@end


/**
 图表的代理
 */
@protocol AXChartViewDelegate <NSObject>

@optional
/**
 选中了某一列
 
 @param index 列索引
 */
- (void)chartView:(AXChartView *)chartView didSelectItemWithIndex:(NSInteger)index;


/**
 将设置渐变色图层
 
 @param gradientLayer 渐变色图层
 */
- (void)chartView:(AXChartView *)chartView willSetGradientLayer:(CAGradientLayer *)gradientLayer;

@end


/**
 图表工具类
 */
@interface AXChartView : UIView

/**
 数据源
 */
@property (weak, nonatomic) id<AXChartViewDataSource> dataSource;

/**
 代理
 */
@property (weak, nonatomic) id<AXChartViewDelegate> delegate;

/**
 线宽，默认值为1
 */
@property (assign, nonatomic) CGFloat lineWidth;

/**
 强调色，默认为灰色（pop视图的主题色）
 */
@property (strong, nonatomic) UIColor *accentColor;

/**
 文本颜色，默认为白色
 */
@property (strong, nonatomic) UIColor *textColor;

/**
 图表标题
 */
@property (copy, nonatomic) NSString *title;


/**
 曲线平滑因数，默认为0（0：折线图，1:非常光滑，取值0~1，越大越失真）
 */
@property (assign, nonatomic) CGFloat smoothFactor;

/**
 重新获取数据并刷新图表
 */
- (void)reloadData;




@end
