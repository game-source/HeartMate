//
//  ReminderTV.m
//  HeartMate
//
//  Created by xaoxuu on 06/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "ReminderTV.h"
#import "HMReminder.h"


@implementation ReminderTV


- (void)ax_tableView:(AXTableViewType *)tableView dataSource:(void (^)(AXTableModelType * _Nonnull))dataSource{
    RLMResults *results = [HMReminder allObjects];
    if (!results.count) {
        return;
    }
    AXTableModel *model = [[AXTableModel alloc] init];
    [model addSection:^(AXTableSectionModel *section) {
        for (int i = 0; i < results.count; i++) {
            HMReminder *reminder = results[i];
            [section addRow:^(AXTableRowModel *row) {
                row.title = reminder.title;
            }];
        }
    }];
    
    
    dataSource(model);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)ax_tableView:(AXTableViewType *)tableView didSetModelForCell:(AXTableViewCellType *)cell atIndexPath:(NSIndexPath *)indexPath{
    
}

@end
