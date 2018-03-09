//
//  NormalTableHeader.h
//  HeartMate
//
//  Created by xaoxuu on 09/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalTableHeader : UITableViewHeaderFooterView

/**
 header height
 */
@property (assign, readonly, class, nonatomic) CGFloat headerHeight;

/**
 title
 */
@property (copy, nonnull, nonatomic) NSString *title;

@end
