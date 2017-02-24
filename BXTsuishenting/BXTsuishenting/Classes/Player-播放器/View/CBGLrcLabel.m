//
//  CBGLrcLabel.m
//  BXTsuishenting
//
//  Created by cbg on 17/02/23.
//  Copyright © 2017年 cbg. All rights reserved.
//



#import "CBGLrcLabel.h"

@implementation CBGLrcLabel

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 1.获取需要画的区域
    CGRect fillRect = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
    
    // 2.设置颜色
    [CBGGreenColor set];
    
    // 3.添加区域
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}


@end
