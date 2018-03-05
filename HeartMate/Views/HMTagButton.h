//
//  HMTagButton.h
//  HeartMate
//
//  Created by xaoxuu on 05/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMTagButton;
@protocol HMTagButtonDelegate <NSObject>

- (void)tagButtonDidTouchUpInside:(HMTagButton *)sender;

@end

@interface HMTagButton : UIButton

/**
 delegate
 */
@property (weak, nonatomic) NSObject<HMTagButtonDelegate> *delegate;

+ (instancetype)defaultButton;

+ (instancetype)buttonWithTag:(NSString *)tag delegate:(NSObject<HMTagButtonDelegate> *)delegate;


@end
