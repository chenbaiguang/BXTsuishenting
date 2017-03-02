//
//  CBGBlurView.m
//  BXTsuishenting
//
//  Created by cbg on 17/3/2.
//  Copyright © 2017年 cbg. All rights reserved.
//

#import "CBGBlurView.h"


static UIVisualEffectView *_effectView;

@implementation CBGBlurView

+ (void)show:(UIView *)view
{
    // 模糊程度
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    // 模糊 view
    _effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _effectView.backgroundColor = CBGRGBColor(137, 203, 149, 0.2);
    // 系统会提示不能这样设置，但是能用
    _effectView.alpha = 0.5;
    _effectView.frame = view.bounds;
    [view addSubview:_effectView];
}

+ (void)hide
{
    [_effectView removeFromSuperview];
    _effectView = nil;
}

@end
