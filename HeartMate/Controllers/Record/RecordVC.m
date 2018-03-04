//
//  RecordVC.m
//  HeartMate
//
//  Created by xaoxuu on 04/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "RecordVC.h"
#import <AXKit/StatusKit.h>

#import "HeartKit.h"
#import "HMHeartRate.h"

static BOOL run = NO;

static UILabel *defaultLabelWithFontSize(CGFloat fontSize){
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.5*kScreenH, kScreenW, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

static NSString *defaultTags(){
    NSDate *date = [NSDate date];
    NSString *tag1 = date.stringValue(@"EE");
    NSString *tag2;
    NSInteger hour = date.stringValue(@"HH").integerValue;
    if (hour > 5 && hour < 9) {
        tag2 = @"早上";
    } else if (hour < 11) {
        tag2 = @"上午";
    } else if (hour < 14) {
        tag2 = @"中午";
    } else if (hour < 19) {
        tag2 = @"下午";
    } else {
        tag2 = @"晚上";
    }
    return [NSString stringWithFormat:@"%@,%@", tag1, tag2];
}

static BOOL prepared = NO;

@interface RecordVC () <HKCaptureSessionDelegate>

@property (strong, nonatomic) HKOutputView *live;

@property (strong, nonatomic) UILabel *largeTitle;

@property (strong, nonatomic) UILabel *statusTips;

@property (strong, nonatomic) UIProgressView *progressView;

@property (strong, nonatomic) UIButton *button;


@end

@implementation RecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    [self setupVisualLayer];
    
    [self setupSubviews];
    
    
    //开启测心率方法
    [HKCaptureSession sharedInstance].delegate = self;
    [HKCaptureSession sharedInstance].expectedDuration = 5;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect)initContentFrame:(CGRect)frame{
    frame.size.height -= kTabBarHeight;
    return frame;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startCapture];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopCapture];
}

- (void)stopCapture{
    run = NO;
    self.button.selected = NO;
    [[HKCaptureSession sharedInstance] stopRunning];
    [[HKCaptureSession sharedInstance].previewLayer removeFromSuperlayer];
}

- (void)startCapture{
    if (prepared) {
        run = YES;
        [self.progressView setProgress:0 animated:NO];
        self.button.selected = YES;
        [[HKCaptureSession sharedInstance] startRunning];
        [HKCaptureSession sharedInstance].previewLayer.frame = CGRectMake(0, 0, kScreenW, kScreenH);
        [self.view.layer insertSublayer:[HKCaptureSession sharedInstance].previewLayer atIndex:0];
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[HKCaptureSession sharedInstance] prepare];
        });
    }
}

- (void)hkCaptureSession:(HKCaptureSession *)session didLoadFinished:(BOOL)finished error:(NSError *)error{
    prepared = finished;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (finished) {
            [self startCapture];
        }
        if (error) {
            [UIAlertController ax_showAlertWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion actions:nil];
        }
    });
}
- (void)hkCaptureSession:(HKCaptureSession *)session timestamp:(NSTimeInterval)timestamp point:(CGFloat)point{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.live drawRateWithPoint:@(point)];
    });
}

- (void)hkCaptureSession:(HKCaptureSession *)session progress:(CGFloat)progress instantHeartRate:(NSInteger)instantHeartRate {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusTips.text = [NSString stringWithFormat:@"%d次/分", (int)instantHeartRate];
        [self.progressView setProgress:progress animated:YES];
    });
}

- (void)hkCaptureSession:(HKCaptureSession *)session didCompletedWithHeartRate:(NSInteger)heartRate detail:(NSArray<NSNumber *> *)detail{
    if (run) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusTips.text = [NSString stringWithFormat:@"%d次/分", (int)heartRate];
            
            NSString *msg = [NSString stringWithFormat:@"\n本次测量的样本为：\n%@", detail.firstObject];
            for (int i = 1; i < detail.count; i++) {
                msg = [msg stringByAppendingFormat:@",%@", detail[i]];
            }
            [UIAlertController ax_showAlertWithTitle:self.statusTips.text message:msg actions:^(UIAlertController * _Nonnull alert) {
                [alert ax_addDefaultActionWithTitle:@"保存" handler:^(UIAlertAction * _Nonnull sender) {
                    [UIAlertController ax_showAlertWithTitle:@"设置标签" message:@"请输入简单的词汇作为标签，用英文逗号分隔。以后你可以通过这些标签进行数据分析。" actions:^(UIAlertController * _Nonnull alert) {
                        HMHeartRate *avgHR = [[HMHeartRate alloc] init];
                        avgHR.time = [NSDate date];
                        [avgHR.detail addObjects:detail];
                        avgHR.heartRate = heartRate;
                        avgHR.note = @"这是测试的备注信息";
                        __block UITextField *tf;
                        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                            tf = textField;
                            textField.text = defaultTags();
                            textField.returnKeyType = UIReturnKeyDone;
                            [textField ax_addEditingEndOnExitHandler:^(__kindof UITextField * _Nonnull sender) {
                                NSArray<NSString *> *tags = [tf.text componentsSeparatedByString:@","];
                                if (tags.count) {
                                    [avgHR.tags addObjects:tags];
                                }
                                RLMRealm *realm = [RLMRealm defaultRealm];
                                [realm transactionWithBlock:^{
                                    [realm addObject:avgHR];
                                }];
                                [self stopCapture];
                            }];
                        }];
                        [alert ax_addDefaultActionWithTitle:@"保存" handler:^(UIAlertAction * _Nonnull sender) {
                            NSArray<NSString *> *tags = [tf.text componentsSeparatedByString:@","];
                            if (tags.count) {
                                [avgHR.tags addObjects:tags];
                            }
                            RLMRealm *realm = [RLMRealm defaultRealm];
                            [realm transactionWithBlock:^{
                                [realm addObject:avgHR];
                            }];
                            [self stopCapture];
                        }];
                        [alert ax_addCancelActionWithTitle:@"不设置标签" handler:^(UIAlertAction * _Nonnull sender) {
                            RLMRealm *realm = [RLMRealm defaultRealm];
                            [realm transactionWithBlock:^{
                                [realm addObject:avgHR];
                            }];
                            [self stopCapture];
                        }];
                    }];
                }];
                [alert ax_addCancelActionWithTitle:@"丢弃" handler:^(UIAlertAction * _Nonnull sender) {
                    [self stopCapture];
                }];
            }];
        });
        
    }
}


- (void)hkCaptureSession:(HKCaptureSession *)session state:(HKCaptureState)state error:(nonnull NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (state == HKCaptureStateError) {
            self.progressView.hidden = YES;
            self.largeTitle.text = @"请用指尖轻轻按住摄像头";
        } else if (state == HKCaptureStatePreparing) {
            self.progressView.hidden = YES;
            self.largeTitle.text = @"正在检测脉搏...";
        } else if (state == HKCaptureStateCapturing) {
            self.progressView.hidden = NO;
            self.largeTitle.text = @"正在测量...";
        } else if (state == HKCaptureStateCompleted) {
            self.progressView.hidden = NO;
            self.largeTitle.text = @"测量完成";
        }
    });
}




- (void)setupVisualLayer{
    UIVisualEffectView *vev = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    UIVisualEffect *ve = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    vev.effect = ve;
    UIView *view = [[UIView alloc] initWithFrame:vev.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [vev.contentView addSubview:view];
    [self.view addSubview:vev];
}



- (void)setupSubviews{
    
    CGFloat centerX = 0.5 * self.view.width;
    CGFloat height = self.view.bounds.size.height;
    self.largeTitle = defaultLabelWithFontSize(24);
    [self.view addSubview:self.largeTitle];
    self.largeTitle.top = 40;
    
    
    //创建一个心电图的View
    self.live = [[HKOutputView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    [self.view addSubview:self.live];
    self.live.center = CGPointMake(centerX, 0.5 * height - 40);
    self.live.backgroundColor = [UIColor clearColor];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    [self.view addSubview:button];
    self.button = button;
    [button.layer ax_whiteBorder:1];
    [button.layer ax_cornerRadius:0.5*button.height shadow:LayerShadowNone];
    button.bottom = height - 20;
    button.centerX = centerX;
    [button setTitle:@"开始测量" forState:UIControlStateNormal];
    [button setTitle:@"结束测量" forState:UIControlStateSelected];
    __weak typeof(self) weakSelf = self;
    [button ax_addTouchUpInsideHandler:^(__kindof UIButton * _Nonnull sender) {
        if (sender.selected) {
            [weakSelf stopCapture];
        } else {
            [weakSelf startCapture];
        }
    }];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 160, 2)];
    [self.view addSubview:progressView];
    progressView.hidden = YES;
    progressView.progress = 0;
    progressView.centerX = centerX;
    progressView.bottom = button.top - 40;
    progressView.tintColor = [UIColor whiteColor];
    progressView.trackTintColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.progressView = progressView;
    
    self.statusTips = defaultLabelWithFontSize(32);
    [self.view addSubview:self.statusTips];
    self.statusTips.bottom = self.progressView.top - 20;
    
}



@end
