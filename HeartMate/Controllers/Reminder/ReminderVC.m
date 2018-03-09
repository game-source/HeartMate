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
#import "ReminderGuideView.h"

@interface ReminderVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<HMReminder *> *results;

@property (strong, nonatomic) ReminderGuideView *reminderGuideView;

@end

@implementation ReminderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ReminderGuideView *view = UIViewFromNibNamed(@"ReminderGuideView");
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    self.reminderGuideView = view;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ax_initNavigationBar{
    if (@available(iOS 11.0, *)) {
        // on newer versions
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
    __weak typeof(self) weakSelf = self;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"icon_plus" action:^(UIBarButtonItem * _Nonnull sender) {
        ReminderEditVC *vc = [[ReminderEditVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (CGRect)ax_contentViewFrame:(CGRect)frame{
    frame.size.height -= kTopBarHeight + kTabBarHeight;
    return frame;
}

- (void)ax_initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(ReminderTVC.class) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass(ReminderTVC.class)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 132;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = axThemeManager.color.background;
    self.tableView.separatorColor = self.tableView.backgroundColor;
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
    
    if (!self.results.count) {
        self.reminderGuideView.hidden = NO;
        [self.reminderGuideView startAnimation];
        if (@available(iOS 11.0, *)) {
            // on newer versions
            self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
        }
    } else {
        self.reminderGuideView.hidden = YES;
        if (@available(iOS 11.0, *)) {
            // on newer versions
            self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
        }
    }
    
}

#pragma mark - func

- (void)reloadData{
    [self.results removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - priv

- (NSMutableArray<HMReminder *> *)results{
    if (!_results.count) {
        _results = [NSMutableArray array];
        RLMResults<HMReminder *> *puppies = [HMReminder allObjects];
        if (puppies.count) {
            puppies = [puppies sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithKeyPath:@"hour" ascending:YES], [RLMSortDescriptor sortDescriptorWithKeyPath:@"minute" ascending:YES]]];
        }
        for (int i = 0; i < puppies.count; i++) {
            [_results addObject:puppies[i]];
        }
    }
    return _results;
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReminderTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ReminderTVC.class) forIndexPath:indexPath];
    cell.model = self.results[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReminderEditVC *vc = [[ReminderEditVC alloc] init];
    vc.reminder = self.results[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
