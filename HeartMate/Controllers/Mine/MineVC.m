//
//  MineVC.m
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "MineVC.h"
#import <AXKit/FeedbackKit.h>
#import "MineTV.h"
#import "HMUser.h"

@interface MineVC ()

@property (strong, nonatomic) MineTV *tableView;

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        // on newer versions
        self.navigationController.navigationBar.prefersLargeTitles = YES;
    } else {
        // Fallback on earlier versions
        
    }
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"icon_talk" action:^(UIBarButtonItem * _Nonnull sender) {
        [[EmailManager sharedInstance] sendEmail:^(MFMailComposeViewController * _Nonnull mailCompose) {
            mailCompose.navigationBar.barStyle = UIBarStyleDefault;
            mailCompose.navigationBar.translucent = NO;
            mailCompose.navigationBar.opaque = YES;
            mailCompose.navigationBar.barTintColor = axThemeManager.color.background;
            mailCompose.navigationBar.tintColor = axThemeManager.color.theme;
            mailCompose.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:axThemeManager.color.theme, NSFontAttributeName:[UIFont fontWithName:axThemeManager.font.name size:20]};
            
            [mailCompose setToRecipients:@[@"feedback@xaoxuu.com"]];
            [mailCompose setSubject:@"Heart Mate"];
            
            
            [mailCompose setMessageBody:[NSString stringWithFormat:@"\n\n\n\napp name:%@ \napp version: %@ (%@)",[NSBundle ax_appDisplayName], [NSBundle ax_appVersion], [NSBundle ax_appBuild]] isHTML:NO];
            
        } completion:^(MFMailComposeResult result) {

        } fail:^(NSError * _Nonnull error) {

        }];
    }];
    
    MineTV *tv = [[MineTV alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tv.backgroundColor = axThemeManager.color.background;
    tv.separatorColor = tv.backgroundColor;
    [self.view addSubview:tv];
    self.tableView = tv;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUserUpdated) name:NOTI_USER_UPDATE object:nil];
    
    [self didUserUpdated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didUserUpdated{
//    [self.tableView reloadDataSourceAndRefreshTableView];
    HMUser *user = [HMUser currentUser];
    if (user) {
        if (user.firstName.length && user.lastName.length) {
            self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        } else if (user.firstName.length) {
            self.navigationItem.title = user.firstName;
        } else if (user.lastName.length) {
            self.navigationItem.title = user.lastName;
        } else {
            self.navigationItem.title = self.title;
        }
    } else {
        
    }
}

- (CGRect)initContentFrame:(CGRect)frame{
    frame.size.height -= kTopBarHeight + kTabBarHeight;
    return frame;
}


@end
