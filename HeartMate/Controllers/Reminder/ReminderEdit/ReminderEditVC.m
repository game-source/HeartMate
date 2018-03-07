//
//  ReminderEditVC.m
//  HeartMate
//
//  Created by xaoxuu on 07/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "ReminderEditVC.h"
#import "BaseTextField.h"
#import "HMWideButton.h"
#import "LocalNotificationManager.h"


static void deleteLocalNotificationWithIdentifier(NSString *identifier){
    for (int i = 0; i <= 7; i++) {
        NSString *fullIdentifier = [NSString stringWithFormat:@"%@.%d", identifier, i];
        [LocalNotificationManager removeNotificationWithIdentifier:fullIdentifier];
    }
}

@interface ReminderEditVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lb_repeat;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet BaseTextField *tf_title;
@property (weak, nonatomic) IBOutlet HMWideButton *btn_done;

@property (strong, nonatomic) NSDate *today;

@property (strong, nonatomic) NSMutableArray<NSNumber *> *weekday;

@property (assign, nonatomic) BOOL createMode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;

@end

@implementation ReminderEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bottomMargin.constant = CGConstGetScreenBottomSafeAreaHeight() ? : 20;
    
    self.title = NSLocalizedString(@"Edit Reminder", @"编辑提醒");
    self.today = [NSDate date];
    
    __weak typeof(self) weakSelf = self;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"icon_delete" action:^(UIBarButtonItem * _Nonnull sender) {
        NSString *title = NSLocalizedString(@"Notice", @"注意");
        NSString *msg = NSLocalizedString(@"Do you really want to delete the reminder?", @"你真的要删除提醒吗？");
        [BaseAlertController ax_showAlertWithTitle:title message:msg actions:^(UIAlertController * _Nonnull alert) {
            [alert ax_addDestructiveActionWithTitle:nil handler:^(UIAlertAction * _Nonnull sender) {
                deleteLocalNotificationWithIdentifier(weakSelf.reminder.identifier);
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    [[RLMRealm defaultRealm] deleteObject:weakSelf.reminder];
                }];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [alert ax_addCancelAction];
        }];
        
    }];
    
    
    self.weekday = [NSMutableArray array];
    
    [self setupTableView];
    
    self.pickerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.pickerView.layer ax_cornerRadius:8 shadow:LayerShadowNone];
    
    if (!self.reminder) {
        self.createMode = YES;
        self.reminder = [[HMReminder alloc] init];
        // 默认选中今天
        [self.weekday addObject:@(self.today.weekday-1)];
    } else {
        for (int i = 0; i < self.reminder.weekday.count; i++) {
            [self.weekday addObject:self.reminder.weekday[i]];
        }
    }
    NSDate *date = [NSDate dateWithString:[NSString stringWithFormat:@"%02d:%02d", (int)self.reminder.hour, (int)self.reminder.minute] format:@"HH:mm"];
    self.pickerView.date = date;
    
    self.tf_title.text = self.reminder.title;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setReminder:(HMReminder *)reminder{
    _reminder = reminder;
    for (int i = 0; i < reminder.weekday.count; i++) {
        [self.weekday addObject:reminder.weekday[i]];
    }
    
}


- (void)setupTableView{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView.layer ax_cornerRadius:8 shadow:LayerShadowNone];
    self.tableView.separatorColor = axThemeManager.color.background;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tf_title resignFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"reminder repeat cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = axThemeManager.font.customNormal;
    }
    cell.textLabel.text = [HMReminder descriptionForWeekday:indexPath.row];
    if ([self.weekday containsObject:@(indexPath.row)]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSNumber *weekday = @(indexPath.row);
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([self.weekday containsObject:weekday]) {
            [self.weekday removeObject:weekday];
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if (![self.weekday containsObject:weekday]) {
            [self.weekday addObject:weekday];
        }
    }
    
    
}

- (void)dealloc{
    AXLogSuccess();
}

- (IBAction)tappedDone:(UIButton *)sender {
    if (self.createMode) {
        // 如果是创造模式，就把这个提醒添加进数据库
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            [[RLMRealm defaultRealm] addObject:self.reminder];
        }];
    }
    
    
    HMReminder *reminder = self.reminder;
    // 进行数据库修改
    [self.reminder transactionWithBlock:^{
        if (self.tf_title.text.length) {
            reminder.title = self.tf_title.text;
        } else {
            reminder.title = NSLocalizedString(@"It's time to measure my heart rate.", @"是时候测量一下心率了。");
        }
        
        [reminder.weekday removeAllObjects];
        for (int i = 0; i < 7; i++) {
            if ([self.weekday containsObject:@(i)]) {
                [reminder.weekday addObject:@(i)];
            }
        }
        NSDate *time = self.pickerView.date;
        reminder.hour = time.hour;
        reminder.minute = time.minute;
    }];
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [LocalNotificationManager prepare];
    });
    
    
    deleteLocalNotificationWithIdentifier(reminder.identifier);
    
    if (self.weekday.count) {
        for (NSNumber *obj in self.weekday) {
            NSString *identifier = [NSString stringWithFormat:@"%@.%@", reminder.identifier, obj];
            [LocalNotificationManager pushNotificationWithIdentifier:identifier dateComponents:^(NSDateComponents *components) {
                [components setWeekday:obj.integerValue+1];
                [components setHour:reminder.hour];
                [components setMinute:reminder.minute];
            } title:nil message:self.reminder.title repeat:YES];
        }
    } else {
        NSString *identifier = [NSString stringWithFormat:@"%@.0", reminder.identifier];
        [LocalNotificationManager pushNotificationWithIdentifier:identifier dateComponents:^(NSDateComponents *components) {
            [components setHour:reminder.hour];
            [components setMinute:reminder.minute];
        } title:nil message:self.reminder.title repeat:NO];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
