//
//  CalendarVC.m
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "CalendarVC.h"
#import "HMUser.h"
#import "HeartRateTableView.h"


static CGFloat minHeightOfCalendar = 320;

@interface CalendarVC () <MDCalendarDelegate>

@property (strong, nonatomic) MDCalendar *calendar;

@property (strong, nonatomic) NSDate *selectedDate;

@property (strong, nonatomic) HeartRateTableView *tableView;

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation CalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        // on newer versions
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    } else {
        // Fallback on earlier versions
        
    }
    NSDate *today = [NSDate date];
    self.navigationItem.title = today.stringValue(@"yyyy-MM-dd");
    
    __weak typeof(self) weakSelf = self;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"icon_position" action:^(UIBarButtonItem * _Nonnull sender) {
        weakSelf.calendar.selectedDate = [NSDate date];
        [weakSelf.calendar reloadData];
        weakSelf.navigationItem.title = weakSelf.calendar.selectedDate.stringValue(@"yyyy-MM-dd");
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:NOTI_HR_UPDATE object:nil];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    [self setupCalendar];
    [self setupTableView];
    
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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)setupCalendar{
    self.selectedDate = [NSDate date];
    UIColor *tintColor = self.view.tintColor;
    MDCalendar *calendar = [[MDCalendar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, minHeightOfCalendar)];
    [self.scrollView addSubview:calendar];
    self.calendar = calendar;
    calendar.delegate = self;
    calendar.theme = MDCalendarThemeLight;
    calendar.tintColor = tintColor;
    calendar.backgroundColor = axThemeManager.color.background;
    NSDate *joinDate = [HMUser currentUser].joinDate;
    calendar.minimumDate = joinDate.addDays(1-joinDate.day);
    calendar.currentDate = self.selectedDate;
    calendar.selectedDate = self.selectedDate;
    calendar.backgroundColors[@(MDCalendarCellStateSelected)] = tintColor;
    calendar.titleColors[@(MDCalendarCellStateToday)] = tintColor;
    calendar.titleColors[@(MDCalendarCellStateWeekend)] = [UIColor md_green];
}

- (void)calendar:(MDCalendar *)calendar didSelectDate:(nullable NSDate *)date{
    calendar.selectedDate = date;
    self.selectedDate = date;
    self.navigationItem.title = calendar.selectedDate.stringValue(@"yyyy-MM-dd");
    [self reloadTableData];
}

- (void)reloadTableData{
    NSString *where = [NSString stringWithFormat:@"year = %d and month = %d and day = %d", (int)self.selectedDate.year, (int)self.selectedDate.month, (int)self.selectedDate.day];
    [self.tableView reloadDataWhere:where ascending:YES];
    [self refreshSize];
}

- (void)setupTableView{
    CGFloat headerHeight = 1;
    self.tableView = [[HeartRateTableView alloc] initWithFrame:CGRectMake(0, self.calendar.bottom-headerHeight, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    self.tableView.showSectionHeader = NO;
    [self.scrollView addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
    self.tableView.tableHeaderView = UIViewWithHeight(headerHeight);
    
}


- (void)refreshSize{
    // 先获取tableView的内容高度
    CGFloat heightOfTableView = self.tableView.contentSize.height;
    // table view 实际等于内容高度
    if (self.tableView.results.count) {
        self.tableView.height = heightOfTableView;
    } else {
        self.tableView.height = 0;
    }
    self.scrollView.contentSize = CGSizeMake(0, self.calendar.height + self.tableView.height);
}


@end
