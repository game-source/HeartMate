//
//  InputTableView.m
//  HeartMate
//
//  Created by xaoxuu on 09/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "InputTableView.h"
#import "InputTableViewCell.h"

@interface InputTableView () <InputTableViewCellDelegate>


/**
 cell
 */
@property (strong, nonatomic) InputTableViewCell *inputCell;

@end


@implementation InputTableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = axThemeManager.color.background;
        self.separatorColor = axThemeManager.color.background;
    }
    return self;
}

- (void)ax_tableView:(AXTableViewType *)tableView dataSource:(void (^)(AXTableModelType * _Nonnull))dataSource{
    AXTableModel *model = [[AXTableModel alloc] init];
    [model addSection:^(AXTableSectionModel *section) {
        section.headerHeight = 8;
        [section addRow:^(AXTableRowModel *row) {
            row.rowHeight = [InputTableViewCell rowHeight];
        }];
    }];
    
    
    dataSource(model);
}

- (void)setInputMode:(BOOL)inputMode{
    if (inputMode) {
        [self.inputCell becomeFirstResponder];
    } else {
        [self.inputCell resignFirstResponder];
    }
}

- (InputTableViewCell *)inputCell{
    if (!_inputCell) {
        _inputCell = [self dequeueReusableCellWithIdentifier:NSStringFromClass(InputTableViewCell.class)];
        if (!_inputCell) {
            _inputCell = [[InputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(InputTableViewCell.class)];
        }
        _inputCell.title = self.title;
        _inputCell.text = self.text;
        _inputCell.delegate = self;
    }
    return _inputCell;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.inputCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    AXTableSectionModel *model = (AXTableSectionModel *)[self modelForSection:section];
    return model.headerHeight;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self startEditing:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self startEditing:NO];
}
- (void)inputCell:(InputTableViewCell *)cell didEditingChanged:(NSString *)text{
    self.text = text;
}
- (void)inputCell:(InputTableViewCell *)cell didEditingEndOnExit:(NSString *)text{
    if (self.block_completion) {
        self.block_completion(text);
    }
}


- (void)startEditing:(BOOL)startEditing{
    if (startEditing) {
        [self.inputCell becomeFirstResponder];
    } else {
        [self.inputCell resignFirstResponder];
    }
}

@end
