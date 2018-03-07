//
//  TimelineVC.m
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "TimelineVC.h"
#import "HMHeartRate.h"
#import "TimelineTVC.h"

static NSDate *today;

@interface TimelineVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<NSMutableArray<HMHeartRate *> *> *results;

@end

@implementation TimelineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        // on newer versions
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    } else {
        // Fallback on earlier versions
        
    }
    today = [NSDate date];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(TimelineTVC.class) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass(TimelineTVC.class)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 107;
    self.tableView.backgroundColor = axThemeManager.color.background;
    self.tableView.separatorColor = self.tableView.backgroundColor;
    [self.view addSubview:self.tableView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect)initContentFrame:(CGRect)frame{
    frame.size.height -= kTopBarHeight + kTabBarHeight;
    return frame;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.results removeAllObjects];
    [self.tableView reloadData];
    
}



- (NSMutableArray<NSMutableArray<HMHeartRate *> *> *)results{
    if (!_results.count) {
        _results = [NSMutableArray array];
        RLMResults<HMHeartRate *> *puppies = [HMHeartRate allObjects];
        if (puppies.count) {
            puppies = [puppies sortedResultsUsingKeyPath:@"time" ascending:NO];
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
    TimelineTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TimelineTVC.class) forIndexPath:indexPath];
    cell.model = self.results[indexPath.section][indexPath.row];
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    HMHeartRate *hr = self.results[section][0];
    return [HMUtilities descriptionForDate:hr.time];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
