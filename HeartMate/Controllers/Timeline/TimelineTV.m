//
//  TimelineTV.m
//  HeartMate
//
//  Created by xaoxuu on 04/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "TimelineTV.h"
#import "HMHeartRate.h"


@implementation TimelineTV

- (void)ax_tableView:(AXTableViewType *)tableView dataSource:(void (^)(AXTableModelType * _Nonnull))dataSource{
    
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    [realm transactionWithBlock:^{
//
//    }];
//
    
    RLMResults<HMHeartRate *> *puppies = [HMHeartRate allObjects];
    if (!puppies.count) {
        return;
    }
    puppies = [puppies sortedResultsUsingKeyPath:@"time" ascending:NO];
    
    AXTableModel *model = [AXTableModel new];
    NSInteger count = puppies.count;
    for (int i = 0; i < count; i++) {
        [model addSection:^(AXTableSectionModel *section) {
            HMHeartRate *hr = [puppies objectAtIndex:i];
            section.headerTitle = hr.time.stringValue(@"MM-dd HH:mm:ss");
            [section addRow:^(AXTableRowModel *row) {
                row.title = NSStringFromNSInteger(hr.heartRate);
                NSMutableString *tags = [NSMutableString string];
                for (int i = 0; i < hr.tags.count; i++) {
                    NSString *tmp = hr.tags[i];
                    if (i) {
                        [tags appendFormat:@", %@", tmp];
                    } else {
                        [tags appendString:tmp];
                    }
                }
                row.detail = tags;
            }];
        }];
    }
    
    dataSource(model);
    
}

@end
