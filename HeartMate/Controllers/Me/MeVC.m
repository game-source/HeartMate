//
//  MeVC.m
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "MeVC.h"
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
        [BaseUtilities sendFeedbackEmail];
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
