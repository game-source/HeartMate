//
//  HeartRateDetailVC.m
//  HeartMate
//
//  Created by xaoxuu on 08/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HeartRateDetailVC.h"
#import "HeartRateDetailTV.h"
#import "AXChartView.h"
#import "HMWideButton.h"

@interface HeartRateDetailVC () <AXChartViewDataSource, AXChartViewDelegate>

@property (strong, nonatomic) HeartRateDetailTV *tableView;

@end

@implementation HeartRateDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)ax_initNavigationBar{
//    self.navigationItem.title = [NSString stringWithFormat:@"%d bpm", (int)self.model.heartRate];
    self.navigationItem.title = NSLocalizedString(@"Detail", @"详情");
    __weak typeof(self) weakSelf = self;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"icon_delete" action:^(UIBarButtonItem * _Nonnull sender) {
        NSString *title = NSLocalizedString(@"Notice", @"注意");
        NSString *msg = NSLocalizedString(@"Do you really want to delete the heart rate record?", @"你真的要删除这条心率记录吗？");
        [BaseAlertController ax_showAlertWithTitle:title message:msg actions:^(UIAlertController * _Nonnull alert) {
            [alert ax_addDestructiveActionWithTitle:nil handler:^(UIAlertAction * _Nonnull sender) {
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    [[RLMRealm defaultRealm] deleteObject:self.model];
                }];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HR_UPDATE object:@(-1)];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [alert ax_addCancelAction];
        }];
    }];
}

- (void)ax_initTableView{
    HeartRateDetailTV *tv = [[HeartRateDetailTV alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tv.backgroundColor = axThemeManager.color.background;
    tv.separatorColor = axThemeManager.color.background;
    tv.model = self.model;
    tv.sectionFooterHeight = 0;
    [self.view addSubview:tv];
    self.tableView = tv;
    
    __weak typeof(self) weakSelf = self;
    HMWideButton *button = [HMWideButton buttonWithType:UIButtonTypeSystem action:^(HMWideButton *sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [button setTitle:NSLocalizedString(@"Done", @"完成") forState:UIControlStateNormal];
    [self.view addSubview:button];
    CGFloat bottomMargin = CGConstGetScreenBottomSafeAreaHeight() ? : 16;
    button.bottom = self.view.height - bottomMargin;
    
    button.centerX = self.view.centerX;
    
    tv.height = button.top - 16;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tableView reloadDataSourceAndRefreshTableView];
}

#pragma mark - chart

/**
 总列数
 
 @return 总列数
 */
- (NSInteger)chartViewItemsCount:(AXChartView *)chartView{
    return self.model.detail.count;
}


/**
 第index列的值
 
 @param index 列索引
 @return 第index列的值
 */
- (NSNumber *)chartView:(AXChartView *)chartView valueForIndex:(NSInteger)index{
    return self.model.detail[index];
}


/**
 第index列的标题
 
 @param index 列索引
 @return 第index列的标题
 */
- (NSString *)chartView:(AXChartView *)chartView titleForIndex:(NSInteger)index{
    return NSStringFromNSInteger(index);
}

- (NSString *)chartView:(AXChartView *)chartView summaryText:(UILabel *)label{
    chartView.title = [LocalizedStringUtilities stringForTime:self.model.time];
//    return [NSString stringWithFormat:@"%d bpm", (int)self.model.heartRate];
    return @"";
}

- (NSNumber *)chartViewMaxValue:(AXChartView *)chartView{
    return @200;
}


@end
