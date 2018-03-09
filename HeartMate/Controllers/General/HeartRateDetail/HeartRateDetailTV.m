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


@interface HeartRateDetailTV ()<AXChartViewDataSource, AXChartViewDelegate>

@property (weak, nonatomic) HeartRateDetailPreviewCell *previewCell;
@property (weak, nonatomic) HeartRateDetailChartCell *chartCell;

@end

@implementation HeartRateDetailTV


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        
        
    }
    return self;
}

- (void)setModel:(HMHeartRate *)model{
    _model = model;
    [self setupHeader];
}

- (void)setupHeader{
    UIView *header = UIViewWithHeight(300);
    
    HeartRateDetailPreviewCell *previewCell = [[HeartRateDetailPreviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:previewReuseIdentifier];
    previewCell.heartRate = self.model.heartRate;
    [header addSubview:previewCell];
    
    HeartRateDetailChartCell *chartCell = [[HeartRateDetailChartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chartReuseIdentifier];
    chartCell.chartView.dataSource = self;
    chartCell.chartView.delegate = self;
    chartCell.chartView.title = [LocalizedStringUtilities stringForTime:self.model.time];
    [header addSubview:chartCell];
    self.chartCell = chartCell;
    
    previewCell.height = 68;
    previewCell.width = header.width;
    previewCell.top = 12;
    chartCell.height = 200;
    chartCell.width = header.width;
    chartCell.top = previewCell.bottom + 8;
    
    
    [chartCell.chartView reloadData];
    self.tableHeaderView = header;
    
    
    
}


- (void)ax_tableView:(AXTableViewType *)tableView dataSource:(void (^)(AXTableModelType * _Nonnull))dataSource{
    if (!originalTitle) {
        originalTitle = self.controller.navigationItem.title;
    }
//    ax_dispatch_cooldown(0, 0.3, self, dispatch_get_main_queue(), ^{
//        [self setupHeader];
//    }, nil);
    
    AXTableModel *model = [[AXTableModel alloc] init];
    [model addSection:^(AXTableSectionModel *section) {
        section.headerTitle = NSLocalizedString(@"Tags", @"标签").capitalizedString;
        section.headerHeight = [NormalTableHeader headerHeight];
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
        if ([model.cmd isEqualToString:@"add.tags"]) {
        AddNewCell *cell = (AddNewCell *)[tableView dequeueReusableCellWithIdentifier:addReuseIdentifier];
        if (!cell) {
            cell = [[AddNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addReuseIdentifier];
        }
        __weak typeof(self) weakSelf = self;
        cell.block_tapped = ^{
            EditTextVC *vc = [[EditTextVC alloc] init];
            vc.editTitle = NSLocalizedString(@"Tag", @"标签").capitalizedString;
            vc.block_completion = ^(NSString *newText) {
                [weakSelf.model transactionWithBlock:^{
                    [weakSelf.model.tags addObject:newText];
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [tableView scrollToBottom];
                });
            };
            [weakSelf.controller.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)ax_tableView:(AXTableViewType *)tableView didSelectedRowAtIndexPath:(NSIndexPath *)indexPath model:(AXTableRowModelType *)model{
    if ([model.cmd isEqualToString:@"tags"]) {
        EditTextVC *vc = [[EditTextVC alloc] init];
        vc.editTitle = NSLocalizedString(@"Tag", @"标签").capitalizedString;
        vc.defaultText = self.model.tags[indexPath.row];
        __weak typeof(self) weakSelf = self;
        vc.block_completion = ^(NSString *newText) {
            [weakSelf.model transactionWithBlock:^{
                weakSelf.model.tags[indexPath.row] = newText;
            }];
        };
        [self.controller.navigationController pushViewController:vc animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AXTableRowModel *model = (AXTableRowModel *)[self modelForRowAtIndexPath:indexPath];
    return model.rowHeight;
}

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
        self.controller.navigationItem.title = [NSString stringWithFormat:@"%d bpm", (int)self.model.heartRate];
    } else {
        self.controller.navigationItem.title = originalTitle;
    }
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
    return @"";
}

- (NSNumber *)chartViewMaxValue:(AXChartView *)chartView{
    return @200;
}


@end
