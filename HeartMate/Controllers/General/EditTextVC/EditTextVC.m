//
//  EditTextVC.m
//  HeartMate
//
//  Created by xaoxuu on 08/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "EditTextVC.h"

@interface EditTextVC ()


@property (weak, nonatomic) IBOutlet UILabel *lb_title;


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
    self.navigationItem.title = NSLocalizedString(@"Edit", @"编辑");
    __weak typeof(self) weakSelf = self;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"icon_save" action:^(UIBarButtonItem * _Nonnull sender) {
        [weakSelf editDidDone];
    }];
}
- (void)ax_initSubview{
    self.tf_input.returnKeyType = UIReturnKeyDone;
    self.tf_input.text = self.defaultText;
    if (self.editTitle.length) {
        self.lb_title.text = [NSString stringWithFormat:NSLocalizedString(@"Please input a new %@:", @"请输入新的%@："), self.editTitle];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tf_input becomeFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.tf_input resignFirstResponder];
}
- (void)editDidDone{
    if (self.block_completion) {
        self.block_completion(self.tf_input.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didEndOnExit:(UITextField *)sender {
    [self editDidDone];
}

@end
