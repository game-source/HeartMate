//
//  HKCaptureSession.m
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HKCaptureSession.h"
#import <AVFoundation/AVFoundation.h>
#import "HKRecord.h"

// 单例
static HKCaptureSession *instance;


// 返回错误数据停顿的时间
static NSTimeInterval wait_t = 1.0f;

// 是否是记录状态
static bool is_recording = NO;

// 周期
static float T = 10;



#pragma mark - 分析瞬时心率

static void analysisInstantHeartRate(NSMutableArray<HKRecord *> *records, void (^completion)(NSInteger hr)){
    
    if (records.count < 40) {
        return;
    }
    
    int count = (int)records.count;
    
    int d_i_c = 0;          //最低峰值的位置 姑且算在中间位置 c->center
    int d_i_l = 0;          //最低峰值左面的最低峰值位置 l->left
    int d_i_r = 0;          //最低峰值右面的最低峰值位置 r->right
    
    
    float trough_c = 0;     //最低峰值的浮点值
    float trough_l = 0;     //最低峰值左面的最低峰值浮点值
    float trough_r = 0;     //最低峰值右面的最低峰值浮点值
    
    // 1.先确定数据中的最低峰值
    for (int i = 0; i < count; i++) {
        float trough = records[i].hue;
        if (trough < trough_c) {
            trough_c = trough;
            d_i_c = i;
        }
    }
    // 2.找到最低峰值以后  以最低峰值为中心 找到前0.5-1.5周期中的最低峰值  和后0.5-1.5周期的最低峰值
    if (d_i_c >= 1.5*T) {
        
        // a.如果最低峰值处在中心位置， 即距离前后都至少有1.5个周期
        if (d_i_c <= count-1.5*T) {
            // 左面最低峰值
            for (int j = d_i_c - 0.5*T; j > d_i_c - 1.5*T; j--) {
                float trough = records[j].hue;
                if ((trough < trough_l)&&(d_i_c-j)<=T) {
                    trough_l = trough;
                    d_i_l = j;
                }
            }
            // 右面最低峰值
            for (int k = d_i_c + 0.5*T; k < d_i_c + 1.5*T; k++) {
                float trough = records[k].hue;
                if ((trough < trough_r)&&(k-d_i_c<=T)) {
                    trough_r = trough;
                    d_i_r = k;
                }
            }
            
        }
        // b.如果最低峰值右面不够1.5个周期 分两种情况 不够0.5个周期和够0.5个周期
        else {
            // b.1 够0.5个周期
            if (d_i_c <count-0.5*T) {
                // 左面最低峰值
                for (int j = d_i_c - 0.5*T; j > d_i_c - 1.5*T; j--) {
                    float trough = records[j].hue;
                    if ((trough < trough_l)&&(d_i_c-j)<=T) {
                        trough_l = trough;
                        d_i_l = j;
                    }
                }
                // 右面最低峰值
                for (int k = d_i_c + 0.5*T; k < count; k++) {
                    float trough = records[k].hue;
                    if ((trough < trough_r)&&(k-d_i_c<=T)) {
                        trough_r = trough;
                        d_i_r = k;
                    }
                }
            }
            // b.2 不够0.5个周期
            else {
                // 左面最低峰值
                for (int j = d_i_c - 0.5*T; j > d_i_c - 1.5*T; j--) {
                    float trough = records[j].hue;
                    if ((trough < trough_l)&&(d_i_c-j)<=T) {
                        trough_l = trough;
                        d_i_l = j;
                    }
                }
            }
        }
        
    }
    // c. 如果左面不够1.5个周期 一样分两种情况  够0.5个周期 不够0.5个周期
    else {
        // c.1 够0.5个周期
        if (d_i_c>0.5*T) {
            // 左面最低峰值
            for (int j = d_i_c - 0.5*T; j > 0; j--) {
                float trough = records[j].hue;
                if ((trough < trough_l)&&(d_i_c-j)<=T) {
                    trough_l = trough;
                    d_i_l = j;
                }
            }
            // 右面最低峰值
            for (int k = d_i_c + 0.5*T; k < d_i_c + 1.5*T; k++) {
                float trough = records[k].hue;
                if ((trough < trough_r)&&(k-d_i_c<=T)) {
                    trough_r = trough;
                    d_i_r = k;
                }
            }
            
        }
        // c.2 不够0.5个周期
        else {
            // 右面最低峰值
            for (int k = d_i_c + 0.5*T; k < d_i_c + 1.5*T; k++) {
                float trough = records[k].hue;
                if ((trough < trough_r)&&(k-d_i_c<=T)) {
                    trough_r = trough;
                    d_i_r = k;
                }
            }
        }
        
    }
    
    // 3. 确定哪一个与最低峰值更接近 用最接近的一个最低峰值测出瞬时心率 60*1000两个峰值的时间差
    if (trough_l-trough_c < trough_r-trough_c) {
        
        double t_c = records[d_i_c].timestamp;
        double t_l = records[d_i_l].timestamp;
        NSInteger fre = (NSInteger)(60*1000)/(t_c - t_l);
        if (fre > 0 && fre < 255) {
            if (completion) {
                completion(fre);
            }
        }
        
    } else {
        double t_c = records[d_i_c].timestamp;
        double t_r = records[d_i_r].timestamp;
        NSInteger fre = (NSInteger)(60*1000)/(t_r - t_c);
        if (fre > 0 && fre < 255) {
            if (completion) {
                completion(fre);
            }
        }
        
    }
    
    // 4.删除过期数据
    if (records.count >= 10) {
        [records removeObjectsInRange:NSMakeRange(0, 10)];
    }
    
}



@interface HKCaptureSession () <AVCaptureVideoDataOutputSampleBufferDelegate>

// 设备
@property (strong, nonatomic) AVCaptureDevice *device;
// 结合输入输出
@property (strong, nonatomic) AVCaptureSession *session;
// 输入设备
@property (strong, nonatomic) AVCaptureDeviceInput *input;
// 输出设备
@property (strong, nonatomic) AVCaptureVideoDataOutput *output;
// 输出的所有点,每个点为{时间戳:值}
@property (strong, nonatomic) NSMutableArray<HKRecord *> *records;
// 所有瞬时心率
@property (strong, nonatomic) NSMutableArray<NSNumber *> *instantHeartRate;


@end

@implementation HKCaptureSession


+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (instancetype)init {
    if (self = [super init]) {
        // 初始化
        self.expectedDuration = 10;
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        self.session = [[AVCaptureSession alloc] init];
        self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
        self.output = [[AVCaptureVideoDataOutput alloc] init];
        self.records = [[NSMutableArray alloc] init];
        self.instantHeartRate = [[NSMutableArray alloc] init];
        if ([self isCaptureSessionAvailable]) {
            [self setupCapture];
        }
    }
    return self;
}

- (void)setExpectedDuration:(NSTimeInterval)expectedDuration{
    _expectedDuration = MAX(5, expectedDuration);
}


- (BOOL)isCaptureSessionAvailable{
    // 判断相机是否可用
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSError *err = [NSError errorWithDomain:@"com.xaoxuu.HeartKit" code:100 userInfo:@{NSLocalizedDescriptionKey: @"相机不可用,或没有使用相机权限。"}];
        if ([self.delegate respondsToSelector:@selector(hkCaptureSession:didInterruptedWithError:)]) {
            [self.delegate hkCaptureSession:self didInterruptedWithError:err];
        }
        return NO;
    }
    
    // 检查闪光灯是否可用
    if (![self.device isTorchModeSupported:AVCaptureTorchModeOn]) {
        NSError *err = [NSError errorWithDomain:@"com.xaoxuu.HeartKit" code:100 userInfo:@{NSLocalizedDescriptionKey: @"闪光灯不可用。"}];
        if ([self.delegate respondsToSelector:@selector(hkCaptureSession:didInterruptedWithError:)]) {
            [self.delegate hkCaptureSession:self didInterruptedWithError:err];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark - 开始

- (void)startRunning {
    is_recording = YES;
    [self.session startRunning];
    [self TorchModeOn:YES];
}

#pragma mark - 结束

- (void)stopRunning {
    is_recording = NO;
    
    [HKRecord reset];
    [self.records removeAllObjects];
    [self.instantHeartRate removeAllObjects];
    
    [self.session stopRunning];
    [self TorchModeOn:NO];
    
}

#pragma mark - 设置摄像头

- (void)setupCapture {
    
    // 配置input output
    [self.session beginConfiguration];
    
    // 设置像素输出格式
    NSNumber *BGRA32Format = [NSNumber numberWithInt:kCVPixelFormatType_32BGRA];
    NSDictionary *setting  = @{(id)kCVPixelBufferPixelFormatTypeKey:BGRA32Format};
    [self.output setVideoSettings:setting];
    // 抛弃延迟的帧
    [self.output setAlwaysDiscardsLateVideoFrames:YES];
    //开启摄像头采集图像输出的子线程
    dispatch_queue_t outputQueue = dispatch_queue_create("com.xaoxuu.HeartKit", DISPATCH_QUEUE_SERIAL);
    // 设置子线程执行代理方法
    [self.output setSampleBufferDelegate:self queue:outputQueue];
    
    // 向session添加
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    // 降低分辨率，减少采样率
    self.session.sessionPreset = AVCaptureSessionPreset640x480;
    // 设置最小的视频帧输出间隔
    self.device.activeVideoMinFrameDuration = CMTimeMake(1, 10);
    
    // 用当前的output 初始化connection
    AVCaptureConnection *connection =[self.output connectionWithMediaType:AVMediaTypeVideo];
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    // 完成编辑
    [self.session commitConfiguration];
    
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
// captureOutput->当前output   sampleBuffer->样本缓冲   connection->捕获连接
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    [HKRecord recordWithSampleBuffer:sampleBuffer completion:^(HKRecord *record) {
        if (is_recording) {
            
            if ([self.delegate respondsToSelector:@selector(hkCaptureSession:didGetRecord:)]) {
                [self.delegate hkCaptureSession:self didGetRecord:record];
            }
            [self.records addObject:record];
            if (self.records.count == 40) {
                // 分析波峰波谷
                analysisInstantHeartRate(self.records, ^(NSInteger hr) {
                    CGFloat pro = ((CGFloat)self.instantHeartRate.count) / self.expectedDuration;
                    pro = MIN(pro, 1);
                    if ([self.delegate respondsToSelector:@selector(hkCaptureSession:didUpdateCapturedProgress:instantHeartRate:)]) {
                        [self.delegate hkCaptureSession:self didUpdateCapturedProgress:pro instantHeartRate:hr];
                    }
                    
                    [self.instantHeartRate addObject:@(hr)];
                    if (pro >= 1) {
                        // 去掉第一个、最大值、最小值，然后求平均值
                        [self.instantHeartRate removeObjectAtIndex:0];
                        [self.instantHeartRate sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                            return [obj1 compare:obj2];
                        }];
                        [self.instantHeartRate removeObjectAtIndex:0];
                        [self.instantHeartRate removeLastObject];
                        NSInteger sum = [[self.instantHeartRate valueForKeyPath:@"@sum.doubleValue"] integerValue];
                        NSInteger avg = sum / self.instantHeartRate.count;
                        if ([self.delegate respondsToSelector:@selector(hkCaptureSession:didCompletedWithAverageHeartRate:)]) {
                            [self.delegate hkCaptureSession:self didCompletedWithAverageHeartRate:avg];
                            [self stopRunning];
                        }
                    }
                });
            }
            
        }
    } error:^(NSError *error) {
        if (is_recording) {
            if ([self.delegate respondsToSelector:@selector(hkCaptureSession:didInterruptedWithError:)]) {
                [self.delegate hkCaptureSession:self didInterruptedWithError:error];
            }
            // 清除数据
            [HKRecord reset];
            [self.records removeAllObjects];
            [self.instantHeartRate removeAllObjects];
            is_recording = NO;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(wait_t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                is_recording = YES;
            });
        }
    }];
}




#pragma mark - priv

- (void)TorchModeOn:(BOOL)on{
    [self.device lockForConfiguration:nil];
    if (on) {
        [self.device setTorchModeOnWithLevel:0.01 error:nil];
    } else {
        self.device.torchMode = AVCaptureTorchModeOff;
    }
    [self.device unlockForConfiguration];
}




@end
