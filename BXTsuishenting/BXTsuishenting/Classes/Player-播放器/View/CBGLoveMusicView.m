//
//  CBGLoveMusicView.m
//  BXTsuishenting
//
//  Created by cbg on 17/02/20.
//  Copyright © 2017年 cbg. All rights reserved.
//

#import "CBGLoveMusicView.h"
#import "CBGLoveMusicCell.h"

@interface CBGLoveMusicView()

@end


@implementation CBGLoveMusicView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupTableView];
    }
    return self;
}

- (void)setupTableView{
    
    self.loveMusicTable = [[UITableView alloc] init];
    self.loveMusicTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.loveMusicTable.rowHeight = (35 * kScreenHeightScale);
    self.loveMusicTable.bounces = NO;
    [self addSubview:self.loveMusicTable];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.loveMusicTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
}


@end
