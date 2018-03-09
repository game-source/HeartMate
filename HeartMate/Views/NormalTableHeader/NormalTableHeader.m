//
//  NormalTableHeader.m
//  HeartMate
//
//  Created by xaoxuu on 09/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "NormalTableHeader.h"


@interface NormalTableHeader ()


/**
 label
 */
@property (strong, nonatomic) UILabel *lb;

@end

@implementation NormalTableHeader

+ (CGFloat)headerHeight{
    return 38;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self _init];
    }
    return self;
}

- (void)_init{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 1, 20)];
    lb.font = axThemeManager.font.customNormal;
    lb.textColor = [UIColor grayColor];
    [self addSubview:lb];
    self.lb = lb;
    self.title = @"a";
    [self.lb sizeToFit];
    lb.bottom = self.class.headerHeight - 8;
    
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.lb.text = title;
    [self.lb sizeToFit];
    self.lb.hidden = !title.length;
}


@end
