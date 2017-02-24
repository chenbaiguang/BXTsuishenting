//
//  CBGLoveMusicCell.h
//  BXTsuishenting
//
//  Created by cbg on 17/02/20.
//  Copyright © 2017年 cbg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBGLoveMusicCell : UITableViewCell

/** Block */
@property (strong, nonatomic) void(^btnClick)();

+ (instancetype)loveMusicCellWithTableView:(UITableView *)tableView;


@end
