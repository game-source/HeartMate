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


@end

@implementation ReminderEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.today = [NSDate date];
    
    self.weekday = [NSMutableArray array];
    
    [self setupTableView];
    
    if (!self.reminder) {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            self.reminder = [[HMReminder alloc] init];
            [[RLMRealm defaultRealm] addObject:self.reminder];
        }];
    } else {
        for (int i = 0; i < self.reminder.weekday.count; i++) {
            [self.weekday addObject:self.reminder.weekday[i]];
        }
        NSDate *date = [NSDate dateWithString:[NSString stringWithFormat:@"%02d:%02d", (int)self.reminder.hour, (int)self.reminder.minute] format:@"HH:mm"];
        self.pickerView.date = date;
        self.tf_title.text = self.reminder.title;
    }
    
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
//    self.tableView.backgroundColor = [UIColor clearColor];
    
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

- (IBAction)tappedDone:(UIButton *)sender {
    NSDate *time = self.pickerView.date;
    [self.reminder transactionWithBlock:^{
        self.reminder.title = self.tf_title.text;
        for (NSNumber *tmp in self.weekday) {
            [self.reminder.weekday addObject:tmp];
        }
        self.reminder.hour = time.hour;
        self.reminder.minute = time.minute;
    }];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
