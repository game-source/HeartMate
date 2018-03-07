//
//  ReminderVC.m
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "ReminderVC.h"
#import "HMReminder.h"
#import "ReminderEditVC.h"
#import "ReminderTVC.h"


@interface ReminderVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<HMReminder *> *results;

@end

@implementation ReminderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        // on newer versions
        self.navigationController.navigationBar.prefersLargeTitles = YES;
    } else {
        // Fallback on earlier versions
        
    }
    
    [self setupTableView];
    
    __weak typeof(self) weakSelf = self;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"icon_add" action:^(UIBarButtonItem * _Nonnull sender) {
        ReminderEditVC *vc = [[ReminderEditVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reload];
    
}

- (CGRect)initContentFrame:(CGRect)frame{
    frame.size.height -= kTopBarHeight + kTabBarHeight;
    return frame;
}


- (void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(ReminderTVC.class) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass(ReminderTVC.class)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 132;
    self.tableView.backgroundColor = axThemeManager.color.background;
    self.tableView.separatorColor = self.tableView.backgroundColor;
    [self.view addSubview:self.tableView];
    
    
    
}

- (void)reload{
    [self.results removeAllObjects];
    [self.tableView reloadData];
}

- (NSMutableArray<HMReminder *> *)results{
    if (!_results.count) {
        _results = [NSMutableArray array];
        RLMResults<HMReminder *> *puppies = [HMReminder allObjects];
        if (puppies.count) {
            puppies = [puppies sortedResultsUsingKeyPath:@"hour" ascending:YES];
        }
        for (int i = 0; i < puppies.count; i++) {
            [_results addObject:puppies[i]];
        }
    }
    return _results;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReminderTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ReminderTVC.class) forIndexPath:indexPath];
    cell.model = self.results[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 132;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReminderEditVC *vc = [[ReminderEditVC alloc] init];
    vc.reminder = self.results[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
