//
//  AddNewCell.h
//  HeartMate
//
//  Created by xaoxuu on 08/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewCell : UITableViewCell

/**
 completion
 */
@property (copy, nonatomic) void (^block_tapped)(void);


@end
