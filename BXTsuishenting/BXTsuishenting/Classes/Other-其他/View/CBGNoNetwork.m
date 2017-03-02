//
//  CBGNoNetwork.m
//  BXTsuishenting
//
//  Created by cbg on 17/3/2.
//  Copyright © 2017年 cbg. All rights reserved.
//

#import "CBGNoNetwork.h"

@interface CBGNoNetwork()

@end

@implementation CBGNoNetwork

+ (void)show
{
    // 创建蒙版对象
    CBGNoNetwork *noNetworkView = [[CBGNoNetwork alloc] init];
    noNetworkView.bounds = CGRectMake(0, 0, 250, 250);
    noNetworkView.center = CBGKeyWindow.center;
    noNetworkView.backgroundColor = CBGRGBColor(137, 203, 149, 1);
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"网络出错";
    [noNetworkView addSubview:label];
    
    // 把蒙版对象添加主窗口
    [CBGKeyWindow addSubview:noNetworkView];
    
    
    
    
}


+ (void)hide
{
    for (UIView *childView in CBGKeyWindow.subviews) {
        if ([childView isKindOfClass:self]) {
            [childView removeFromSuperview];
        }
    }
}
@end
