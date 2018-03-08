//
//  HeartRateDetailTV.m
//  HeartMate
//
//  Created by xaoxuu on 08/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HeartRateDetailTV.h"
#import "HeartRateDetailVC.h"
#import "AXChartView.h"
#import "HeartRateDetailChartCell.h"
#import "HeartRateDetailPreviewCell.h"
#import "HMUser.h"
#import "EditTextVC.h"
#import "AddNewCell.h"

static NSString *chartReuseIdentifier = @"HeartRateDetailChartCell";
static NSString *previewReuseIdentifier = @"HeartRateDetailPreviewCell";
static NSString *addReuseIdentifier = @"AddNewCell";

static NSString *originalTitle;

@interface HeartRateDetailTV ()

@property (weak, nonatomic) HeartRateDetailVC<AXChartViewDataSource, AXChartViewDelegate> *vc;

@end

@implementation HeartRateDetailTV


- (HeartRateDetailVC *)vc{
    return (HeartRateDetailVC<AXChartViewDataSource, AXChartViewDelegate> *)self.controller;
}

- (void)ax_tableView:(AXTableViewType *)tableView dataSource:(void (^)(AXTableModelType * _Nonnull))dataSource{
    if (!originalTitle) {
        originalTitle = self.vc.navigationItem.title;
    }
    AXTableModel *model = [[AXTableModel alloc] init];
    [model addSection:^(AXTableSectionModel *section) {
        [section addRow:^(AXTableRowModel *row) {
            row.cmd = @"hr.preview";
        }];
    }];
    [model addSection:^(AXTableSectionModel *section) {
        section.headerHeight = 8;
        [section addRow:^(AXTableRowModel *row) {
            row.cmd = @"chart.hr";
        }];
    }];
    //    [model addSection:^(AXTableSectionModel *section) {
    //        [section addRow:^(AXTableRowModel *row) {
    //            row.title = @"my age";
    //            row.cmd = @"user.age";
    //        }];
    //        [section addRow:^(AXTableRowModel *row) {
    //            row.title = @"my BMI";
    //            row.cmd = @"user.bmi";
    //        }];
    //    }];
    
    if (self.model.tags.count) {
        [model addSection:^(AXTableSectionModel *section) {
            section.headerTitle = @"Tags";
            for (int i = 0; i < self.model.tags.count; i++) {
                [section addRow:^(AXTableRowModel *row) {
                    row.title = self.model.tags[i];
                    row.cmd = @"tags";
                }];
            }
            [section addRow:^(AXTableRowModel *row) {
                row.cmd = @"add.tags";
            }];
        }];
    } else {
        [model addSection:^(AXTableSectionModel *section) {
            [section addRow:^(AXTableRowModel *row) {
                row.cmd = @"add.tags";
            }];
        }];
    }
    
    dataSource(model);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AXTableRowModelType *model = [self modelForRowAtIndexPath:indexPath];
    if ([model.cmd isEqualToString:@"hr.preview"]) {
        HeartRateDetailPreviewCell *cell = (HeartRateDetailPreviewCell *)[tableView dequeueReusableCellWithIdentifier:previewReuseIdentifier];
        if (!cell) {
            cell = [[HeartRateDetailPreviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:previewReuseIdentifier];
        }
        cell.heartRate = self.model.heartRate;
        return cell;
    } else if ([model.cmd isEqualToString:@"chart.hr"]) {
        HeartRateDetailChartCell *cell = (HeartRateDetailChartCell *)[tableView dequeueReusableCellWithIdentifier:chartReuseIdentifier];
        if (!cell) {
            cell = [[HeartRateDetailChartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chartReuseIdentifier];
        }
        cell.chartView.dataSource = self.vc;
        cell.chartView.delegate = self.vc;
        [cell.chartView reloadData];
        return cell;
    } else if ([model.cmd isEqualToString:@"add.tags"]) {
        AddNewCell *cell = (AddNewCell *)[tableView dequeueReusableCellWithIdentifier:addReuseIdentifier];
        if (!cell) {
            cell = [[AddNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addReuseIdentifier];
        }
        __weak typeof(self) weakSelf = self;
        cell.block_tapped = ^{
            EditTextVC *vc = [[EditTextVC alloc] init];
            vc.editTitle = NSLocalizedString(@"tag", @"标签");
            vc.block_completion = ^(NSString *newText) {
                [weakSelf.model transactionWithBlock:^{
                    [weakSelf.model.tags addObject:newText];
                }];
            };
            [weakSelf.vc.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}


//- (void)ax_tableView:(AXTableViewType *)tableView willSetModel:(AXTableRowModel *)model forRowAtIndexPath:(NSIndexPath *)indexPath{
//    HMUser *user = [HMUser allObjects].lastObject;
//    if (!user) {
//        return;
//    }
//    if ([model.cmd isEqualToString:@"user.age"]) {
//        model.detail = NSStringFromNSInteger([NSDate date].year - user.birthday.year);
//    } else if ([model.cmd isEqualToString:@"user.bmi"]) {
//        CGFloat bmi = [BaseUtilities bmiWithHeight:user.height/100.0 weight:user.weight];
//        model.detail = [NSString stringWithFormat:@"%.1f", bmi];
//    }
//}

- (void)ax_tableView:(AXTableViewType *)tableView didSelectedRowAtIndexPath:(NSIndexPath *)indexPath model:(AXTableRowModelType *)model{
    if ([model.cmd isEqualToString:@"tags"]) {
        EditTextVC *vc = [[EditTextVC alloc] init];
        vc.editTitle = NSLocalizedString(@"tag", @"标签");
        vc.defaultText = self.model.tags[indexPath.row];
        __weak typeof(self) weakSelf = self;
        vc.block_completion = ^(NSString *newText) {
            [weakSelf.model transactionWithBlock:^{
                weakSelf.model.tags[indexPath.row] = newText;
            }];
        };
        [self.vc.navigationController pushViewController:vc animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 200;
    } else {
        return kTableViewCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 8;
    } else {
        return -1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else {
        return -1;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    if (offset.y > kTableViewCellHeight) {
        self.vc.navigationItem.title = [NSString stringWithFormat:@"%d bpm", (int)self.model.heartRate];
    } else {
        self.vc.navigationItem.title = originalTitle;
    }
}


@end
