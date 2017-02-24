//
//  CBGAnimationView.m
//  aaaaa
//
//  Created by cbg on 16/11/17.
//  Copyright © 2016年 cbg. All rights reserved.
//

#import "CBGAnimationView.h"

@implementation CBGAnimationView

+ (void)showScreenshotInHidePoint:(CGPoint)hidePoint
                   screenshotRect:(CGRect)frame
                   screenshotView:(UIView *)view
{
    // 创建活动菜单
    CBGAnimationView  *menu = [[CBGAnimationView alloc] init];
    
    menu.frame = frame;
    menu.backgroundColor = [UIColor greenColor];
    
    [[UIApplication sharedApplication].keyWindow addSubview:menu];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, menu.frame.size.width, menu.frame.size.height);
    imageView.image = [menu imageWithView:imageView with:view];
    [menu addSubview:imageView];
    
    [UIView animateWithDuration:1 animations:^{
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        transform = CGAffineTransformTranslate(transform, -menu.center.x + hidePoint.x, -menu.center.y + hidePoint.y);
        
        transform = CGAffineTransformScale(transform, 0.01, 0.01);
        
        menu.transform = transform;
        
    } completion:^(BOOL finished) {        
        
        [menu removeFromSuperview];
    }];
}

- (UIImage *)imageWithView:(UIView *)image with:(UIView *)inView{

    UIImage *img;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.bounds.size.width, image.bounds.size.height), YES, 0.0);
    [inView.layer renderInContext:UIGraphicsGetCurrentContext()];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
