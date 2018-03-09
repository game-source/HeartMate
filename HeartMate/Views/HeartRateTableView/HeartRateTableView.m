//
//  HeartRateTableView.m
//  HeartMate
//
//  Created by xaoxuu on 07/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HeartRateTableView.h"
#import "HeartRateTableViewCell.h"
#import "HeartRateDetailVC.h"
#import "NormalTableHeader.h"


@interface HeartRateTableView() <UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSString *where;

@end

@implementation HeartRateTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass(HeartRateTableViewCell.class) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass(HeartRateTableViewCell.class)];
        self.dataSource = self;
        self.delegate = self;
        self.estimatedRowHeight = 107;
        self.tableHeaderView = UIViewWithHeight(20);
        self.backgroundColor = [UIColor clearColor];
        self.separatorColor = axThemeManager.color.background;
        self.showSectionHeader = YES;
    }
    return self;
}


- (void)reloadDataWhere:(NSString *)where ascending:(BOOL)ascending{
    self.where = where;
    self.ascending = ascending;
    [self.results removeAllObjects];
    [self reloadData];
}


- (NSMutableArray<NSMutableArray<HMHeartRate *> *> *)results{
    if (!_results.count) {
        _results = [NSMutableArray array];
        RLMResults<HMHeartRate *> *puppies;
        if (self.where.length) {
            puppies = [HMHeartRate objectsWhere:self.where];
        } else {
            puppies = [HMHeartRate allObjects];
        }
        if (puppies.count) {
            puppies = [puppies sortedResultsUsingKeyPath:@"time" ascending:self.ascending];
        }
        if (puppies.count) {
            for (int i = 0; i < puppies.count; i++) {
                NSMutableArray<HMHeartRate *> *group = [NSMutableArray array];
                [group addObject:puppies[i++]];
                HMHeartRate *hr0 = group[0];
                while (i < puppies.count) {
                    HMHeartRate *hr = puppies[i];
                    if (hr.year == hr0.year && hr.month == hr0.month && hr.day == hr0.day) {
                        [group addObject:hr];
                    } else {
                        i--;
                        break;
                    }
                    i++;
                }
                [_results addObject:group];
            }
        }
        
    }
    return _results;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.results.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.results[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HeartRateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(HeartRateTableViewCell.class) forIndexPath:indexPath];
    cell.model = self.results[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (self.showSectionHeader) {
//        HMHeartRate *hr = self.results[section][0];
//        return [BaseUtilities descriptionForDate:hr.time];
//    } else {
//        return nil;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return NormalTableHeader.headerHeight * self.showSectionHeader;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NormalTableHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(NormalTableHeader.class)];
    if (!header) {
        header = [[NormalTableHeader alloc] initWithReuseIdentifier:NSStringFromClass(NormalTableHeader.class)];
    }
    if (self.showSectionHeader) {
        HMHeartRate *hr = self.results[section].firstObject;
        header.title = [BaseUtilities descriptionForDate:hr.time];
    } else {
        header.title = @"";
    }
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HeartRateDetailVC *vc = [[HeartRateDetailVC alloc] init];
    vc.model = self.results[indexPath.section][indexPath.row];
    [self.controller.navigationController pushViewController:vc animated:YES];
}


@end
