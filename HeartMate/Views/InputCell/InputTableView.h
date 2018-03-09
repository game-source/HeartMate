//
//  InputTableView.h
//  HeartMate
//
//  Created by xaoxuu on 09/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <AXKit/AXKit.h>
#import "InputTableViewCell.h"

@interface InputTableView : AXTableView

/**
 current text
 */
@property (copy, nonatomic) NSString *title;

/**
 current text
 */
@property (copy, nonatomic) NSString *text;

@property (copy, nonatomic) void (^block_completion)(NSString *text);


/**
 开始编辑

 @param startEditing 开始编辑
 */
- (void)startEditing:(BOOL)startEditing;

@end
