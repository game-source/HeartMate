//
//  TimelineVC.m
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "TimelineVC.h"
#import "HMHeartRate.h"
#import "HeartRateTableView.h"
#import "TimelineGuideView.h"

static NSDate *today;

@interface TimelineVC ()

@property (strong, nonatomic) HeartRateTableView *tableView;
@property (strong, nonatomic) TimelineGuideView *timelineGuideView;
@end

@implementation TimelineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TimelineGuideView *view = UIViewFromNibNamed(@"TimelineGuideView");
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    self.timelineGuideView = view;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect)ax_contentViewFrame:(CGRect)frame{
    frame.size.height -= kTopBarHeight + kTabBarHeight;
    return frame;
}

- (void)ax_initProperty{
    today = [NSDate date];
}

- (void)ax_initNavigationBar{
    if (@available(iOS 11.0, *)) {
        // on newer versions
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
}

- (void)ax_initTableView{
    self.tableView = [[HeartRateTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadDataWhere:nil ascending:NO];
    
    static NSString *welcomeTitle;
    if (!welcomeTitle.length) {
        welcomeTitle = NSLocalizedString(@"Welcome", @"欢迎");
    }
    if (!self.tableView.results.count) {
        self.timelineGuideView.hidden = NO;
        [self.timelineGuideView startAnimation];
        self.navigationItem.title = welcomeTitle;
        if (@available(iOS 11.0, *)) {
            // on newer versions
            self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
        }
    } else {
        self.timelineGuideView.hidden = YES;
        if ([self.navigationItem.title isEqualToString:welcomeTitle]) {
            self.navigationItem.title = NSLocalizedString(@"Timeline", @"时间线");
        }
        if (@available(iOS 11.0, *)) {
            // on newer versions
            self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
//    [self.timelineGuideView stopAnimation];
}


@end
