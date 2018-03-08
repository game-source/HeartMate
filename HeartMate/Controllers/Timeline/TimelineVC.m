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
#import "GuideView.h"

static NSDate *today;

@interface TimelineVC ()

@property (strong, nonatomic) HeartRateTableView *tableView;
@property (strong, nonatomic) GuideView *guideView;
@end

@implementation TimelineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GuideView *view = UIViewFromNibNamed(@"GuideView");
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    self.guideView = view;
    
    
    
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
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!self.tableView.results.count) {
        self.guideView.hidden = NO;
        [BaseAnimationThread resumeAnimation];
        self.navigationItem.title = NSLocalizedString(@"Welcome", @"欢迎");
        if (@available(iOS 11.0, *)) {
            // on newer versions
            self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
        }
    } else {
        self.guideView.hidden = YES;
        self.navigationItem.title = NSLocalizedString(@"Timeline", @"时间线");
        if (@available(iOS 11.0, *)) {
            // on newer versions
            self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
//    [self.guideView stopAnimation];
}


@end
