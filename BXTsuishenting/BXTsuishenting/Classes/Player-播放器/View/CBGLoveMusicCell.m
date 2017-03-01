//
//  CBGLoveMusicCell.m
//  BXTsuishenting
//
//  Created by cbg on 17/02/20.
//  Copyright © 2017年 cbg. All rights reserved.
//

#import "CBGLoveMusicCell.h"

@implementation CBGLoveMusicCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        NSLog(@"%f",self.frame.size.height);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"x" forState:UIControlStateNormal];
        [btn setTitleColor:CBGGreenColor forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(-3 * kScreenHeightScale, 0, 0, 0);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addTarget:self action:@selector(heartAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10 * kScreenWidthScale);
            make.top.bottom.equalTo(0);
            make.width.equalTo(self.frame.size.height);
        }];
    }
    return self;
}

+ (instancetype)loveMusicCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    CBGLoveMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[CBGLoveMusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (void)heartAction
{
    NSLog(@"点击了爱心");
    if(self.btnClick){
        self.btnClick();
    }
}


@end
