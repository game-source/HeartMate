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


@end

@implementation CalendarVC

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect)ax_contentViewFrame:(CGRect)frame{
    frame.size.height -= kTopBarHeight + kTabBarHeight;
    return frame;
}
- (void)ax_initData{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:NOTI_HR_UPDATE object:nil];
}
- (void)ax_initNavigationBar{
    NSDate *today = [NSDate date];
    self.navigationItem.title = today.stringValue(@"yyyy-MM-dd");
    if (@available(iOS 11.0, *)) {
        // on newer versions
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    } else {
        // Fallback on earlier versions
        
    }
    __weak typeof(self) weakSelf = self;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"icon_position" action:^(UIBarButtonItem * _Nonnull sender) {
        weakSelf.calendar.selectedDate = [NSDate date];
        [weakSelf.calendar reloadData];
        weakSelf.navigationItem.title = weakSelf.calendar.selectedDate.stringValue(@"yyyy-MM-dd");
    }];
}

- (void)ax_initTableView{
    self.tableView = [[HeartRateTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    self.tableView.showSectionHeader = NO;
    [self.view addSubview:self.tableView];
    [self setupCalendar];
    self.tableView.tableHeaderView = self.calendar;
    [self reloadTableData];
}

- (void)setupCalendar{
    self.selectedDate = [NSDate date];
    UIColor *tintColor = self.view.tintColor;
    MDCalendar *calendar = [[MDCalendar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, minHeightOfCalendar)];
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


#pragma mark - func

- (void)reloadTableData{
    NSString *where = [NSString stringWithFormat:@"year = %d and month = %d and day = %d", (int)self.selectedDate.year, (int)self.selectedDate.month, (int)self.selectedDate.day];
    [self.tableView reloadDataWhere:where ascending:NO];
}


#pragma mark - priv



#pragma mark - delegate

- (void)calendar:(MDCalendar *)calendar didSelectDate:(nullable NSDate *)date{
    calendar.selectedDate = date;
    self.selectedDate = date;
    self.navigationItem.title = calendar.selectedDate.stringValue(@"yyyy-MM-dd");
    [self reloadTableData];
}

@end
