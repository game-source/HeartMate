//
//  CalendarVC.m
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "CalendarVC.h"


@interface CalendarVC () <MDCalendarDelegate>

@property (strong, nonatomic) MDCalendar *calendar;

@property (strong, nonatomic) NSDate *selectedDate;

@end

@implementation CalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBarHidden = YES;
    
    UIColor *tintColor = self.view.tintColor;
    MDCalendar *calendar = [[MDCalendar alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:calendar];
    self.calendar = calendar;
    calendar.delegate = self;
    calendar.theme = MDCalendarThemeLight;
    calendar.tintColor = tintColor;
    calendar.backgroundColor = axThemeManager.color.background;
    calendar.currentDate = [NSDate date];
    calendar.selectedDate = [NSDate date];
    calendar.backgroundColors[@(MDCalendarCellStateSelected)] = tintColor;
    calendar.titleColors[@(MDCalendarCellStateToday)] = tintColor;
    calendar.titleColors[@(MDCalendarCellStateWeekend)] = [UIColor md_green];
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"icon_position" action:^(UIBarButtonItem * _Nonnull sender) {
        calendar.selectedDate = [NSDate date];
        [calendar reloadData];
    }];
    
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

- (void)calendar:(MDCalendar *)calendar didSelectDate:(nullable NSDate *)date{
    calendar.selectedDate = date;
    self.selectedDate = date;
}



@end
