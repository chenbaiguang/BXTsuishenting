//
//  CBGLrcCell.m
//  BXTsuishenting
//
//  Created by cbg on 17/02/20.
//  Copyright © 2017年 cbg. All rights reserved.
//

#import "CBGLrcCell.h"
#import "CBGLrcLabel.h"
#import "Masonry.h"

@implementation CBGLrcCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        CBGLrcLabel *lrcLabel = [[CBGLrcLabel alloc] init];
        lrcLabel.textColor = [UIColor blackColor];
        lrcLabel.font = [UIFont systemFontOfSize:(16.0 * kScreenHeightScale)];
        lrcLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:lrcLabel];
        _lrcLabel = lrcLabel;
        lrcLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"LrcCell";
    CBGLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CBGLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


@end
