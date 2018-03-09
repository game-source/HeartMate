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

static NSString *originalTitle;

static CGFloat cellHeight = 107;

@interface HeartRateTableView() <UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSString *where;

@property (strong, nonatomic) NSMutableArray<NSNumber *> *sectionTop;

@property (strong, nonatomic) NSMutableArray<NSString *> *sectionTitle;

@end

@implementation HeartRateTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass(HeartRateTableViewCell.class) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass(HeartRateTableViewCell.class)];
        self.dataSource = self;
        self.delegate = self;
        self.estimatedRowHeight = cellHeight;
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
        if (!originalTitle) {
            originalTitle = self.controller.navigationItem.title;
        }
    }
    return _results;
}

- (NSMutableArray<NSNumber *> *)sectionTop{
    if (!_sectionTop.count) {
        _sectionTop = [NSMutableArray arrayWithCapacity:self.results.count];
        for (int i = 0; i < self.results.count; i++) {
            [_sectionTop addObject:@0];
        }
    }
    return _sectionTop;
}

- (NSMutableArray<NSString *> *)sectionTitle{
    if (!_sectionTitle.count) {
        _sectionTitle = [NSMutableArray arrayWithCapacity:self.results.count];
        for (int i = 0; i < self.results.count; i++) {
            [_sectionTitle addObject:@""];
        }
    }
    return _sectionTitle;
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
    return cellHeight;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (self.showSectionHeader) {
//        HMHeartRate *hr = self.results[section][0];
//        return [BaseUtilities stringForDate:hr.time];
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
        header.title = [LocalizedStringUtilities stringForDate:hr.time];
    } else {
        header.title = @"";
    }
    self.sectionTitle[section] = header.title;
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HeartRateDetailVC *vc = [[HeartRateDetailVC alloc] init];
    vc.model = self.results[indexPath.section][indexPath.row];
    [self.controller.navigationController pushViewController:vc animated:YES];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.showSectionHeader) {
        return;
    }
    
    for (int i = 0; i < self.results.count; i++) {
        if (self.results[i].count) {
            UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            CGFloat top = cell.top - [NormalTableHeader headerHeight];
            if (top > 0) {
                self.sectionTop[i] = @(top);
            }
            
        }
    }
    
    CGPoint offset = scrollView.contentOffset;
    if (self.sectionTop.count) {
        for (int i = (int)self.sectionTop.count-1; i >= 0; i--) {
            CGFloat top = self.sectionTop[i].doubleValue;
            if (top <= 0) {
                continue;
            }
            if (offset.y > top) {
                self.controller.navigationItem.title = self.sectionTitle[i];
                return;
            }
        }
        self.controller.navigationItem.title = originalTitle;
    } else {
        self.controller.navigationItem.title = originalTitle;
    }
}


@end
