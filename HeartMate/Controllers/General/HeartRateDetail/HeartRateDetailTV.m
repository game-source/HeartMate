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
#import "NormalTableHeader.h"

static NSString *chartReuseIdentifier = @"HeartRateDetailChartCell";
static NSString *previewReuseIdentifier = @"HeartRateDetailPreviewCell";
static NSString *addReuseIdentifier = @"AddNewCell";

static NSString *originalTitle;

@interface HeartRateDetailTV ()

@property (weak, nonatomic) HeartRateDetailVC<AXChartViewDataSource, AXChartViewDelegate> *vc;

@end

@implementation HeartRateDetailTV


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.sectionHeaderHeight = [NormalTableHeader headerHeight];
    }
    return self;
}

- (HeartRateDetailVC *)vc{
    return (HeartRateDetailVC<AXChartViewDataSource, AXChartViewDelegate> *)self.controller;
}

- (void)ax_tableView:(AXTableViewType *)tableView dataSource:(void (^)(AXTableModelType * _Nonnull))dataSource{
    if (!originalTitle) {
        originalTitle = self.vc.navigationItem.title;
    }
    AXTableModel *model = [[AXTableModel alloc] init];
    [model addSection:^(AXTableSectionModel *section) {
        section.headerHeight = 12;
        section.footerHeight = 4;
        [section addRow:^(AXTableRowModel *row) {
            row.cmd = @"hr.preview";
            row.rowHeight = 68;
        }];
    }];
    [model addSection:^(AXTableSectionModel *section) {
        section.headerHeight = 4;
        section.footerHeight = 8;
        [section addRow:^(AXTableRowModel *row) {
            row.cmd = @"chart.hr";
            row.rowHeight = 200;
        }];
    }];
    
    [model addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"Tags";
        for (int i = 0; i < self.model.tags.count; i++) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = self.model.tags[i];
                row.cmd = @"tags";
                row.rowHeight = kTableViewCellHeight;
            }];
        }
        [section addRow:^(AXTableRowModel *row) {
            row.cmd = @"add.tags";
            row.rowHeight = kTableViewCellHeight;
        }];
    }];
    
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
            vc.editTitle = NSLocalizedString(@"Tag", @"标签");
            vc.block_completion = ^(NSString *newText) {
                [weakSelf.model transactionWithBlock:^{
                    [weakSelf.model.tags addObject:newText];
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [tableView scrollToBottom];
                });
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
        vc.editTitle = NSLocalizedString(@"Tag", @"标签");
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        return 68;
//    } else if (indexPath.section == 1) {
//        return 200;
//    } else {
//        return kTableViewCellHeight;
//    }
//}
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    AXTableSectionModel *model = (AXTableSectionModel *)[self modelForSection:section];
    return model.headerHeight;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    AXTableSectionModel *model = (AXTableSectionModel *)[self modelForSection:section];
    if (model.headerTitle.length) {
        NormalTableHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(NormalTableHeader.class)];
        if (!header) {
            header = [[NormalTableHeader alloc] initWithReuseIdentifier:NSStringFromClass(NormalTableHeader.class)];
        }
        header.title = model.headerTitle;
        return header;
    } else {
        return nil;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    AXTableSectionModel *model = (AXTableSectionModel *)[self modelForSection:section];
    return model.footerHeight;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.model transactionWithBlock:^{
            [self.model.tags removeObjectAtIndex:indexPath.row];
        }];
        [self reloadDataSource];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
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
