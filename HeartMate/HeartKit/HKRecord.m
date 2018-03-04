//
//  HKRecord.m
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HKRecord.h"




// 记录浮点变化的前一次的值
static float lastH = 0;
// 用于判断是否是第一个福点值
static int   count = 0;

// 测量精度 1，2，3... 数值越小精度越高
static float accuracy = 2;

#pragma mark - 根据h返回 浮点

static float HeartRate (float h) {
    float low = 0;
    count++;
    lastH = (count==1)?h:lastH;
    low = (h-lastH);
    lastH = h;
    return low;
}

#pragma mark - 计算RGB

static void TORGB (uint8_t *buf, float ww, float hh, size_t pr, float *r, float *g, float *b) {
    
    float wh = (float)(ww * hh );
    for(int y = 0; y < hh; y++) {
        for(int x = 0; x < ww * 4; x += 4) {
            *b += buf[x];
            *g += buf[x+1];
            *r += buf[x+2];
        }
        buf += pr;
    }
    *r /= 255 * wh;
    *g /= 255 * wh;
    *b /= 255 * wh;
}


#pragma mark --- 获取颜色变化的算法

static void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v ) {
    float min, max, delta;
    min = MIN( r, MIN(g, b ));
    max = MAX( r, MAX(g, b ));
    *v = max;
    delta = max - min;
    if( max != 0 )
        *s = delta / max;
    else {
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;
    else if( g == max )
        *h = 2 + (b - r) / delta;
    else
        *h = 4 + (r - g) / delta;
    *h *= 60;
    if( *h < 0 )
        *h += 360;
}



@implementation HKRecord

+ (instancetype)recordWithTimestamp:(NSTimeInterval)timestamp hue:(CGFloat)hue{
    HKRecord *record = [[HKRecord alloc] init];
    record.timestamp = timestamp;
    record.hue = hue;
    return record;
}

+ (void)reset{
    // 清除数据
    count = 0;
    lastH = 0;
}

+ (void)recordWithSampleBuffer:(CMSampleBufferRef)sampleBuffer completion:(void (^)(HKRecord *))completion error:(void (^)(NSError *))error{
    if (!completion) {
        return;
    }
    //获取图层缓冲
    CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    uint8_t*buf = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    float r = 0, g = 0,b = 0;
    float h,s,v;
    // 计算RGB
    TORGB(buf, width, height, bytesPerRow, &r, &g, &b);
    // RGB转HSV
    RGBtoHSV(r, g, b, &h, &s, &v);
    
    // 返回处理后的浮点值
    float hue = HeartRate(h);
    
    BOOL available = (hue > -accuracy && hue < accuracy);
    
    if (available) {
        // 获取当前时间戳（精确到毫秒）
        NSTimeInterval t = [[NSDate date] timeIntervalSince1970]*1000;
        HKRecord *record = [HKRecord recordWithTimestamp:t hue:hue/accuracy];
        completion(record);
    } else {
        if (error) {
            NSString *errStr = @"请将手指覆盖住后置摄像头和闪光灯";
            NSError *err = [NSError errorWithDomain: errStr code:101 userInfo:@{@"content":errStr}];
            error(err);
        }
    }
    
}



@end
