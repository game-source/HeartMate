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


static BOOL isCameraAvailable = NO;
static BOOL isFlashlightAvailable = NO;


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
/**
 图像预览层，实时显示捕获的图像
 */
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;



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
        self.expectedDuration = [NSUserDefaults ax_readDoubleForKey:CACHE_CAPTURE_DURATION];
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        self.session = [[AVCaptureSession alloc] init];
        self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
        self.output = [[AVCaptureVideoDataOutput alloc] init];
        self.records = [[NSMutableArray alloc] init];
        self.instantHeartRate = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)setExpectedDuration:(NSTimeInterval)expectedDuration{
    _expectedDuration = MAX(5, expectedDuration);
    [NSUserDefaults ax_setDouble:expectedDuration forKey:CACHE_CAPTURE_DURATION];
}

- (void)prepare{
    if ([self isCaptureSessionAvailable]) {
        [self setupCapture];
        if ([self.delegate respondsToSelector:@selector(hkCaptureSession:didLoadFinished:error:)]) {
            NSError *error;
            if (!isFlashlightAvailable) {
                error = [NSError ax_errorWithMaker:^(NSErrorMaker * _Nonnull error) {
                    error.localizedDescription = @"闪光灯不可用";
                    error.localizedRecoverySuggestion = @"请尽量对准光线强烈的地方进行测试";
                }];
            }
            [self.delegate hkCaptureSession:self didLoadFinished:YES error:nil];
        }
    } else {
        NSError *error = [NSError ax_errorWithMaker:^(NSErrorMaker * _Nonnull error) {
            error.localizedDescription = @"相机不可用或者没有使用权限";
        }];
        if ([self.delegate respondsToSelector:@selector(hkCaptureSession:didLoadFinished:error:)]) {
            [self.delegate hkCaptureSession:self didLoadFinished:NO error:error];
        }
    }
}


- (BOOL)isCaptureSessionAvailable{
    
    // 判断相机是否可用
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined){
        isCameraAvailable = YES;
    }
    
    // 检查闪光灯是否可用
    if ([self.device isTorchModeSupported:AVCaptureTorchModeOn]) {
        isFlashlightAvailable = YES;
    }
    
    return isCameraAvailable;
}

#pragma mark - 开始

- (void)startRunning {
    is_recording = YES;
    self.state = HKCaptureStateUnknown;
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
    
    
    //使用self.captureSession，初始化预览层，self.captureSession负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer = self.videoPreviewLayer;
    
    
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
            if (!self.instantHeartRate.count) {
                [self updateState:HKCaptureStatePreparing error:nil];
            }
            if ([self.delegate respondsToSelector:@selector(hkCaptureSession:timestamp:point:)]) {
                [self.delegate hkCaptureSession:self timestamp:record.timestamp/1000.0f point:record.hue];
            }
            [self.records addObject:record];
            if (self.records.count == 40) {
                CGFloat max = [[self.records valueForKeyPath:@"hue.@max.doubleValue"] doubleValue];
                CGFloat min = [[self.records valueForKeyPath:@"hue.@min.doubleValue"] doubleValue];
                max = fabs(max);
                min = fabs(min);
                max = MAX(max, min);
                AXLogDouble(max);
                if (max < 0.1) {
                    NSError *error = [NSError ax_errorWithMaker:^(NSErrorMaker * _Nonnull error) {
                        error.code = 102;
                        error.localizedDescription = @"请将手指覆盖住后置摄像头和闪光灯";
                    }];
                    [self updateState:HKCaptureStateError error:error];
                }
                
                // 分析波峰波谷
                analysisInstantHeartRate(self.records, ^(NSInteger hr) {
                    [self updateState:HKCaptureStateCapturing error:nil];
                    CGFloat pro = ((CGFloat)self.instantHeartRate.count) / self.expectedDuration;
                    pro = MIN(pro, 1);
                    
                    if ([self.delegate respondsToSelector:@selector(hkCaptureSession:progress:instantHeartRate:)]) {
                        [self.delegate hkCaptureSession:self progress:pro instantHeartRate:hr];
                    }
                    
                    [self.instantHeartRate addObject:@(hr)];
                    if (pro >= 1) {
                        NSArray *detail = [NSArray arrayWithArray:self.instantHeartRate];
                        // 去掉第一个、最大值、最小值，然后求平均值
                        [self.instantHeartRate removeObjectAtIndex:0];
                        [self.instantHeartRate sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                            return [obj1 compare:obj2];
                        }];
                        [self.instantHeartRate removeObjectAtIndex:0];
                        [self.instantHeartRate removeLastObject];
                        NSInteger sum = [[self.instantHeartRate valueForKeyPath:@"@sum.doubleValue"] integerValue];
                        NSInteger avg = sum / self.instantHeartRate.count;
                        
                        [self updateState:HKCaptureStateCompleted error:nil];
                        if ([self.delegate respondsToSelector:@selector(hkCaptureSession:didCompletedWithHeartRate:detail:)]) {
                            [self.delegate hkCaptureSession:self didCompletedWithHeartRate:avg detail:detail];
                            [self stopRunning];
                        }
                    }
                });
            }
            
        }
    } error:^(NSError *error) {
        if (is_recording) {
            [self updateState:HKCaptureStateError error:error];
        }
    }];
}


- (void)updateState:(HKCaptureState)state error:(NSError *)error{
    if (self.state != state) {
        self.state = state;
        if ([self.delegate respondsToSelector:@selector(hkCaptureSession:state:error:)]) {
            [self.delegate hkCaptureSession:self state:self.state error:error];
        }
    }
    if (error) {
        // 清除数据
        [HKRecord reset];
        [self.records removeAllObjects];
        [self.instantHeartRate removeAllObjects];
        is_recording = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(wait_t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            is_recording = YES;
        });
    }
}


#pragma mark - priv

- (void)TorchModeOn:(BOOL)on{
    if ([self.device isTorchModeSupported:AVCaptureTorchModeOn]) {
        [self.device lockForConfiguration:nil];
        if (on) {
            [self.device setTorchModeOnWithLevel:0.01 error:nil];
        } else {
            self.device.torchMode = AVCaptureTorchModeOff;
        }
        [self.device unlockForConfiguration];
    }
}




@end
