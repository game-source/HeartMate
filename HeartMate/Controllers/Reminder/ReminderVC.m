//
//  ReminderVC.m
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "ReminderVC.h"
#import "HMReminder.h"
#import "ReminderTV.h"

@interface ReminderVC ()

@property (strong, nonatomic) ReminderTV *tableView;

@end

@implementation ReminderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    ReminderTV *tv = [[ReminderTV alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tv.backgroundColor = axThemeManager.color.background;
    tv.separatorColor = tv.backgroundColor;
    [self.view addSubview:tv];
    self.tableView = tv;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReminderUpdated) name:NOTI_REMINDER_UPDATE object:nil];
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"icon_add" action:^(UIBarButtonItem * _Nonnull sender) {
        HMReminder *reminder = [[HMReminder alloc] init];
        [reminder.weekday addObject:@1];
        [reminder.weekday addObject:@3];
        [reminder transactionWithBlock:^{
            [[RLMRealm defaultRealm] addObject:reminder];
        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGRect)initContentFrame:(CGRect)frame{
    frame.size.height -= kTopBarHeight + kTabBarHeight;
    return frame;
}


- (void)didReminderUpdated{
    
}


@end
