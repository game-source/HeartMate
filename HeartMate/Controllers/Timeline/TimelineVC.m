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

@interface TimelineVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) RLMResults<HMHeartRate *> *puppies;

@property (strong, nonatomic) NSMutableArray<NSMutableArray<HMHeartRate *> *> *results;

@end

@implementation TimelineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(TimelineTVC.class) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass(TimelineTVC.class)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 104;
    
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
    
    
}

- (RLMResults<HMHeartRate *> *)puppies{
    if (!_puppies.count) {
        _puppies = [HMHeartRate allObjects];
        if (_puppies.count) {
            _puppies = [_puppies sortedResultsUsingKeyPath:@"time" ascending:NO];
        }
    }
    return _puppies;
}

- (NSMutableArray<NSMutableArray<HMHeartRate *> *> *)results{
    if (!_results) {
        _results = [NSMutableArray array];
        if (self.puppies.count) {
            for (int i = 0; i < self.puppies.count; i++) {
                NSMutableArray<HMHeartRate *> *group = [NSMutableArray array];
                [group addObject:self.puppies[i++]];
                HMHeartRate *hr0 = group[0];
                while (i < self.puppies.count) {
                    HMHeartRate *hr = self.puppies[i];
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
    return hr.time.stringValue(@"yyyy-MM-dd");
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
