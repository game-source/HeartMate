//
//  InputTableViewCell.h
//  HeartMate
//
//  Created by xaoxuu on 09/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTextField.h"

@class InputTableViewCell;
@protocol InputTableViewCellDelegate <NSObject>

- (void)inputCell:(InputTableViewCell *)cell didEditingChanged:(NSString *)text;

- (void)inputCell:(InputTableViewCell *)cell didEditingEndOnExit:(NSString *)text;

@end

@interface InputTableViewCell : UITableViewCell

@property (assign, readonly, class, nonatomic) CGFloat rowHeight;

/**
 current text
 */
@property (copy, nonatomic) NSString *title;

/**
 current text
 */
@property (copy, nonatomic) NSString *text;

/**
 delegate
 */
@property (weak, nonatomic) NSObject<InputTableViewCellDelegate> *delegate;

@end
