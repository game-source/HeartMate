//
//  TimelineVC.m
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "TimelineVC.h"
#import <AXKit/StatusKit.h>

#import "HeartKit.h"
#import "HeartLive.h"


static BOOL run = NO;
static BOOL animated = NO;


@interface TimelineVC () <HKCaptureSessionDelegate>

@property (strong, nonatomic) HeartLive *live;
@property (strong, nonatomic) UILabel *label;

@end

@implementation TimelineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //创建了一个心电图的View
    self.live = [[HeartLive alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 150)];
    [self.view addSubview:self.live];
    self.live.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 30)];
    
    self.label.textColor = [UIColor blackColor];
    self.label.font = [UIFont systemFontOfSize:28];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    
    //开启测心率方法
    [HKCaptureSession sharedInstance].delegate = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)hkCaptureSession:(HKCaptureSession *)session didGetRecord:(HKRecord *)record{
    [self.live drawRateWithPoint:@(record.hue)];
    dispatch_async(dispatch_get_main_queue(), ^{
        [AXStatusBar getCustomStatusBar].backgroundColor = [UIColor md_blue];
        if (!animated) {
            [[AXStatusBar getCustomStatusBar].layer ax_animatedColor:[UIColor whiteColor] duration:2 repeatCount:HUGE_VALF];
            animated = YES;
        }
    });
}

- (void)hkCaptureSession:(HKCaptureSession *)session didUpdateCapturedProgress:(CGFloat)progress instantHeartRate:(NSInteger)instantHeartRate {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.label.text = [NSString stringWithFormat:@"%d次/分", (int)instantHeartRate];
        [AXStatusBar showStatusBarProgress:progress textColor:[UIColor whiteColor] backgroundColor:[UIColor md_green] duration:5];
    });
}

- (void)hkCaptureSession:(HKCaptureSession *)session didCompletedWithAverageHeartRate:(NSInteger)averageHeartRate{
    if (run) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertController ax_showAlertWithTitle:NSStringFromNSInteger(averageHeartRate) message:nil actions:nil];
            self.label.text = [NSString stringWithFormat:@"%d次/分", (int)averageHeartRate];
            [AXStatusBar getCustomStatusBar].backgroundColor = [UIColor clearColor];
            animated = NO;
            [[AXStatusBar getCustomStatusBar].layer ax_removeColorAnimation];
        });
    }
}

- (void)hkCaptureSession:(HKCaptureSession *)session didInterruptedWithError:(NSError *)error{
    if (run) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [AXStatusBar getCustomStatusBar].backgroundColor = [UIColor md_red];
            animated = NO;
            [[AXStatusBar getCustomStatusBar].layer ax_removeColorAnimation];
        });
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (run) {
        run = NO;
        [[HKCaptureSession sharedInstance] stopRunning];
        [AXStatusBar getCustomStatusBar].backgroundColor = [UIColor clearColor];
        animated = NO;
        [[AXStatusBar getCustomStatusBar].layer ax_removeColorAnimation];
    } else {
        run = YES;
        [[HKCaptureSession sharedInstance] startRunning];
        [AXStatusBar getCustomStatusBar].backgroundColor = [UIColor md_blue];
    }
}

@end
