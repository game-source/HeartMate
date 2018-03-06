//
//  MineVC.m
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "MineVC.h"
#import <AXKit/FeedbackKit.h>

@interface MineVC ()

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"icon_talk" action:^(UIBarButtonItem * _Nonnull sender) {
        [[EmailManager sharedInstance] sendEmail:^(MFMailComposeViewController * _Nonnull mailCompose) {
            mailCompose.navigationBar.barStyle = UIBarStyleDefault;
            mailCompose.navigationBar.translucent = NO;
            mailCompose.navigationBar.opaque = YES;
            mailCompose.navigationBar.barTintColor = axThemeManager.color.background;
            mailCompose.navigationBar.tintColor = axThemeManager.color.theme;
            mailCompose.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:axThemeManager.color.theme, NSFontAttributeName:[UIFont fontWithName:axThemeManager.font.name size:20]};
            
            [mailCompose setToRecipients:@[@"me@xaoxuu.com"]];
            [mailCompose setSubject:@"Heart Mate Feedback"];
        } completion:^(MFMailComposeResult result) {

        } fail:^(NSError * _Nonnull error) {

        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect)initContentFrame:(CGRect)frame{
    frame.size.height -= kTopBarHeight + kTabBarHeight;
    return frame;
}


@end
