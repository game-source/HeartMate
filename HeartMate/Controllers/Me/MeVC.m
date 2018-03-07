//
//  MeVC.m
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "MeVC.h"
#import <AXKit/FeedbackKit.h>
#import "MeTV.h"
#import "HMUser.h"

@interface MeVC ()

@property (strong, nonatomic) MeTV *tableView;

@end

@implementation MeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)ax_initProperty{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUserUpdated) name:NOTI_USER_UPDATE object:nil];
}
- (void)ax_initNavigationBar{
    if (@available(iOS 11.0, *)) {
        // on newer versions
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"icon_service" action:^(UIBarButtonItem * _Nonnull sender) {
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
}

- (void)ax_initTableView{
    MeTV *tv = [[MeTV alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tv.backgroundColor = axThemeManager.color.background;
    tv.separatorColor = tv.backgroundColor;
    [self.view addSubview:tv];
    self.tableView = tv;
    [self didUserUpdated];
}

- (CGRect)ax_contentViewFrame:(CGRect)frame{
    frame.size.height -= kTopBarHeight + kTabBarHeight;
    return frame;
}

#pragma mark - func


- (void)didUserUpdated{
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
    }
}

@end
