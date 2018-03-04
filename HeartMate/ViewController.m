//
//  ViewController.m
//  CardiotachMate
//
//  Created by xaoxuu on 22/12/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "ViewController.h"
#import <AXKit/AXKit.h>
#import <AXKit/StatusKit.h>

#import "HeartLive.h"
#import "HKCaptureSession.h"

static BOOL run = NO;
static BOOL animated = NO;

@interface ViewController ()<HKCaptureSessionDelegate>

@property (strong, nonatomic) HeartLive *live;
@property (strong, nonatomic) UILabel *label;
@property (weak, nonatomic) IBOutlet UISlider *sli;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //创建了一个心电图的View
    self.live = [[HeartLive alloc]initWithFrame:CGRectMake(10, 100, self.view.frame.size.width-20, 150)];
    self.live.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.live];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 30)];
    self.label.layer.borderColor = [UIColor blackColor].CGColor;
    self.label.layer.borderWidth = 1;
    self.label.textColor = [UIColor blackColor];
    self.label.font = [UIFont systemFontOfSize:28];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    
    //开启测心率方法
    [HKCaptureSession sharedInstance].delegate = self;
    self.sli.value = [HKCaptureSession sharedInstance].expectedDuration;
    
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
        self.label.text = [NSString stringWithFormat:@"%ld次/分",(long)instantHeartRate];
        [AXStatusBar showStatusBarProgress:progress textColor:[UIColor whiteColor] backgroundColor:[UIColor md_green] duration:5];
    });
}

- (void)hkCaptureSession:(HKCaptureSession *)session didCompletedWithAverageHeartRate:(NSInteger)averageHeartRate{
    if (run) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertController ax_showAlertWithTitle:NSStringFromNSInteger(averageHeartRate) message:nil actions:nil];
            [AXStatusBar getCustomStatusBar].backgroundColor = [UIColor md_red];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)slide:(UISlider *)sender {
    [HKCaptureSession sharedInstance].expectedDuration = sender.value;
}

@end
