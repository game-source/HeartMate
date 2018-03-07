//
//  MeTV.m
//  HeartMate
//
//  Created by xaoxuu on 06/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "MeTV.h"
#import "HMUser.h"
#import "HMGenderPicker.h"
#import "HMBirthdayPicker.h"
#import "HMHeightPicker.h"
#import "HMWeightPicker.h"
#import <AXKit/StatusKit.h>

static HMUser *user;

@implementation MeTV

- (AXTableModelType *)ax_tableViewPreloadDataSource{
    AXTableModel *model = [[AXTableModel alloc] init];
    [model addSection:^(AXTableSectionModel *section) {
        [section addRow:^(AXTableRowModel *row) {
            row.title = NSLocalizedString(@"Nickname", @"");
            row.cmd = @"user.input.name";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = NSLocalizedString(@"Gender", @"");
            row.cmd = @"user.gender";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = NSLocalizedString(@"Email", @"");
            row.cmd = @"user.input.email";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = NSLocalizedString(@"Phone Number", @"");
            row.cmd = @"user.input.phone";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = NSLocalizedString(@"Age", @"");
            row.cmd = @"user.age";
        }];
    }];
    [model addSection:^(AXTableSectionModel *section) {
        [section addRow:^(AXTableRowModel *row) {
            row.title = NSLocalizedString(@"Height", @"");
            row.cmd = @"user.height";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = NSLocalizedString(@"Weight", @"");
            row.cmd = @"user.weight";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = NSLocalizedString(@"BMI", @"");
            row.cmd = @"user.bmi";
        }];
    }];
    [model addSection:^(AXTableSectionModel *section) {
        [section addRow:^(AXTableRowModel *row) {
            row.title = NSLocalizedString(@"App Version", @"");
            row.cmd = @"about.version";
            row.detail = [BaseUtilities descriptionForAppVersion];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = NSLocalizedString(@"Developer", @"");
            row.cmd = @"about.developer";
            row.detail = @"xaoxuu.com";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = NSLocalizedString(@"Feedback", @"");
            row.cmd = @"about.feedback";
        }];
    }];
    return model;
}

- (void)ax_tableView:(AXTableViewType *)tableView dataSource:(void (^)(AXTableModelType * _Nonnull))dataSource{
    user = [HMUser currentUser];
    [self reloadData];
}


- (void)ax_tableView:(AXTableViewType *)tableView willSetModel:(AXTableRowModel *)model forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!user) {
        return;
    }
    
    if ([model.cmd containsString:@"user.input"]) {
        if ([model.cmd isEqualToString:@"user.input.name"]) {
            model.detail = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        } else if ([model.cmd isEqualToString:@"user.input.email"]) {
            model.detail = user.email;
        } else if ([model.cmd isEqualToString:@"user.input.phone"]) {
            model.detail = user.phone;
        }
    } else if ([model.cmd isEqualToString:@"user.gender"]) {
        model.detail = [HMUser descriptionForGender:user.gender];
    } else if ([model.cmd isEqualToString:@"user.age"]) {
        model.detail = NSStringFromNSInteger([NSDate date].year - user.birthday.year);
    } else if ([model.cmd isEqualToString:@"user.height"]) {
        model.detail = [NSString stringWithFormat:@"%d cm", (int)user.height];
    } else if ([model.cmd isEqualToString:@"user.weight"]) {
        model.detail = [NSString stringWithFormat:@"%.1f kg", user.weight];
    } else if ([model.cmd isEqualToString:@"user.bmi"]) {
        CGFloat bmi = [BaseUtilities bmiWithHeight:user.height/100.0 weight:user.weight];
        model.detail = [NSString stringWithFormat:@"%.1f", bmi];
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kTableViewCellHeight;
}


- (void)ax_tableView:(AXTableViewType *)tableView didSelectedRowAtIndexPath:(NSIndexPath *)indexPath model:(AXTableRowModelType *)model{
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Edit %@", @"修改"), model.title];
    if ([model.cmd containsString:@"user.input."]) {
        [BaseAlertController ax_showAlertWithTitle:title message:[NSString stringWithFormat:@"please input a new %@:", model.title.lowercaseString] actions:^(UIAlertController * _Nonnull alert) {
            __block UITextField *tf;
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                tf = textField;
                tf.returnKeyType = UIReturnKeyDone;
                if ([model.cmd isEqualToString:@"user.input.phone"]) {
                    textField.keyboardType = UIKeyboardTypePhonePad;
                }
                textField.placeholder = model.detail;
                [textField ax_addEditingEndOnExitHandler:^(__kindof UITextField * _Nonnull sender) {
                    
                }];
            }];
            [alert ax_addDefaultActionWithTitle:nil handler:^(UIAlertAction * _Nonnull sender) {
                if (tf) {
                    [tf endEditing:YES];
                    if ([model.cmd isEqualToString:@"user.input.name"]) {
                        [user transactionWithBlock:^{
                            user.lastName = tf.text;
                        }];
                    } else if ([model.cmd isEqualToString:@"user.input.email"]) {
                        if ([BaseUtilities validatedEmail:tf.text]) {
                            [user transactionWithBlock:^{
                                user.email = tf.text;
                            }];
                        } else {
                            NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"Please input a valid %@.", @"请输入一个有效的%@。"), model.title.lowercaseString];
                            [BaseAlertController ax_showAlertWithTitle:NSLocalizedString(@"Error", @"错误") message:msg actions:nil];
                        }
                    } else if ([model.cmd isEqualToString:@"user.input.phone"]) {
                        [user transactionWithBlock:^{
                            user.phone = tf.text;
                        }];
//                        if ([BaseUtilities validatedPhoneNumber:tf.text]) {
//                            [user transactionWithBlock:^{
//                                user.phone = tf.text;
//                            }];
//                        } else {
//                            NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"Please input a valid %@.", @"请输入一个有效的%@。"), model.title.lowercaseString];
//                            [BaseAlertController ax_showAlertWithTitle:NSLocalizedString(@"Error", @"错误") message:msg actions:nil];
//                        }
                    }
                    
                    [self reloadRowAtIndexPath:indexPath];
                }
            }];
            [alert ax_addCancelAction];
        }];
    } else if ([model.cmd isEqualToString:@"user.gender"]) {
        [BaseAlertController ax_showActionSheetWithTitle:title message:@"\n\n\n\n\n" actions:^(UIAlertController * _Nonnull alert) {
            HMGenderPicker *picker = [[HMGenderPicker alloc] initWithFrame:CGRectMake(8, kNavBarHeight, kScreenW - 10 * 2 - 8 * 2, 100)];
            [alert.view addSubview:picker];
            [alert ax_addDefaultActionWithTitle:nil handler:^(UIAlertAction * _Nonnull sender) {
                [user transactionWithBlock:^{
                    user.gender = [picker selectedRowInComponent:0];
                }];
                
                [self reloadRowAtIndexPath:indexPath];
            }];
            [alert ax_addCancelAction];
        }];
    } else if ([model.cmd isEqualToString:@"user.age"]) {
        [BaseAlertController ax_showActionSheetWithTitle:title message:@"\n\n\n\n\n" actions:^(UIAlertController * _Nonnull alert) {
            HMBirthdayPicker *picker = [[HMBirthdayPicker alloc] initWithFrame:CGRectMake(8, kNavBarHeight, kScreenW - 10 * 2 - 8 * 2, 100)];
            [alert.view addSubview:picker];
            [alert ax_addDefaultActionWithTitle:nil handler:^(UIAlertAction * _Nonnull sender) {
                [user transactionWithBlock:^{
                    user.birthday = picker.date;
                }];
                [self reloadRowAtIndexPath:indexPath];
            }];
            [alert ax_addCancelAction];
        }];
    } else if ([model.cmd isEqualToString:@"user.height"]) {
        [BaseAlertController ax_showActionSheetWithTitle:title message:@"\n\n\n\n\n" actions:^(UIAlertController * _Nonnull alert) {
            HMHeightPicker *picker = [[HMHeightPicker alloc] initWithFrame:CGRectMake(8, kNavBarHeight, kScreenW - 10 * 2 - 8 * 2, 100)];
            [alert.view addSubview:picker];
            [alert ax_addDefaultActionWithTitle:nil handler:^(UIAlertAction * _Nonnull sender) {
                [user transactionWithBlock:^{
                    user.height = picker.value.doubleValue;
                }];
                [self reloadRowAtIndexPath:indexPath];
                [self reloadRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section+1]];
            }];
            [alert ax_addCancelAction];
        }];
    } else if ([model.cmd isEqualToString:@"user.weight"]) {
        [BaseAlertController ax_showActionSheetWithTitle:title message:@"\n\n\n\n\n" actions:^(UIAlertController * _Nonnull alert) {
            HMWeightPicker *picker = [[HMWeightPicker alloc] initWithFrame:CGRectMake(8, kNavBarHeight, kScreenW - 10 * 2 - 8 * 2, 100)];
            [alert.view addSubview:picker];
            [alert ax_addDefaultActionWithTitle:nil handler:^(UIAlertAction * _Nonnull sender) {
                [user transactionWithBlock:^{
                    user.weight = picker.value.doubleValue;
                }];
                [self reloadRowAtIndexPath:indexPath];
                [self reloadRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section+1]];
            }];
            [alert ax_addCancelAction];
        }];
    }
    
    
    else if ([model.cmd isEqualToString:@"about.developer"]) {
        [UIApplication ax_presentSafariViewControllerWithURL:[BaseUtilities developerURL] fromViewController:self.controller];
    } else if ([model.cmd isEqualToString:@"about.feedback"]) {
        [BaseUtilities sendFeedbackEmail];
    }
    
    
    
}


- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath{
    user = [HMUser currentUser];
    [self reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
