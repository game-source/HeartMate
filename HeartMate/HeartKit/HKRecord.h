//
//  HKRecord.h
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HKRecord : NSObject

/**
 timestamp
 */
@property (assign, nonatomic) NSTimeInterval timestamp;

/**
 (-1 ~ 1)
 */
@property (assign, nonatomic) CGFloat hue;


+ (void)recordWithSampleBuffer:(CMSampleBufferRef)sampleBuffer completion:(void (^)(HKRecord *record))completion error:(void (^)(NSError *error))error;

+ (void)reset;

@end
