//
//  CBGLrcCell.h
//  BXTsuishenting
//
//  Created by cbg on 17/02/20.
//  Copyright © 2017年 cbg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBGLrcLabel;

@interface CBGLrcCell : UITableViewCell

@property (nonatomic, weak, readonly) CBGLrcLabel *lrcLabel;

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;

@end
