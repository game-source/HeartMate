//
//  EditTextVC.m
//  HeartMate
//
//  Created by xaoxuu on 08/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "EditTextVC.h"
#import "InputTableView.h"


@interface EditTextVC ()


@property (strong, nonatomic) InputTableView *tableView;

@end

@implementation EditTextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)ax_initNavigationBar{
    if (self.editTitle.length) {
        self.navigationItem.title = self.editTitle;
    }
    if (!self.navigationItem.title.length) {
        self.navigationItem.title = NSLocalizedString(@"Edit", @"编辑");
    }
    __weak typeof(self) weakSelf = self;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"icon_save" action:^(UIBarButtonItem * _Nonnull sender) {
        [weakSelf editDidDone];
    }];
}


- (void)ax_initTableView{
    InputTableView *tv = [[InputTableView alloc] initWithFrame:self.view.bounds];
    tv.title = [NSString stringWithFormat:NSLocalizedString(@"Please input a new %@:", @"请输入新的%@："), self.editTitle.lowercaseString];
    tv.text = self.defaultText;
    __weak typeof(self) weakSelf = self;
    tv.block_completion = ^(NSString *text) {
        [weakSelf editDidDone];
    };
    [self.view addSubview:tv];
    self.tableView = tv;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView startEditing:YES];
}



- (void)editDidDone{
    if (self.block_completion) {
        self.block_completion(self.tableView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
