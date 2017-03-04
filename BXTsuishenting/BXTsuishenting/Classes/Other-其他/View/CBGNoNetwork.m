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
    CBGNoNetwork *noNetworkView = [[self alloc] init];
    noNetworkView.backgroundColor = CBGRGBColor(250, 250, 250, 1) ;
    noNetworkView.layer.cornerRadius = 7;
    noNetworkView.layer.borderColor = [UIColor whiteColor].CGColor;
    noNetworkView.layer.borderWidth = 1;
    [CBGKeyWindow addSubview:noNetworkView];
    [noNetworkView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(CBGKeyWindow);
        make.width.equalTo(835 * CBGScreenWidth / 1080);
        make.height.equalTo(600 * CBGScreenHeight / 1920);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"网络出错";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18 * kScreenHeightScale];
    label.textColor = CBGRGBColor(208, 79, 86, 1);
    [noNetworkView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(0);
        make.width.equalTo(noNetworkView);
        make.height.equalTo(noNetworkView).dividedBy(4);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = CBGRGBColor(128, 128, 128, 0.2);
    [noNetworkView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.bottom);
        make.centerX.equalTo(noNetworkView);
        make.width.equalTo(noNetworkView).offset(-50 * kScreenWidthScale);
        make.height.equalTo(1);
    }];
    
    UIView *closeView = [[UIView alloc] init];
    closeView.layer.cornerRadius = 7;
    closeView.backgroundColor = CBGRGBColor(237, 238, 241, 1);
    [noNetworkView addSubview:closeView];
    [closeView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(noNetworkView);
        make.width.equalTo(noNetworkView);
        make.height.equalTo(label);
        make.bottom.equalTo(noNetworkView);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"向下拉关闭提示(待做)";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:16 * kScreenHeightScale];
    label3.textColor = CBGRGBColor(128, 128, 128, 1);
    label3.backgroundColor = [UIColor clearColor];
    [closeView addSubview:label3];
    [label3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(0);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"请连接网络后，重新尝试";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:14 * kScreenHeightScale];
    [noNetworkView addSubview:label2];
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.bottom);
        make.centerX.equalTo(noNetworkView);
        make.width.equalTo(noNetworkView);
        make.bottom.equalTo(closeView.top);
    }];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = CBGRGBColor(128, 128, 128, 0.2);
    [noNetworkView addSubview:lineView2];
    [lineView2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.bottom);
        make.centerX.equalTo(noNetworkView);
        make.width.equalTo(noNetworkView);
        make.height.equalTo(1);
    }];
    
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
