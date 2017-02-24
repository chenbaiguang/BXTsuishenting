//
//  CBGAnimationView.h
//  aaaaa
//
//  Created by cbg on 16/11/17.
//  Copyright © 2016年 cbg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBGAnimationView : UIView

/**
*  截屏，平移并缩小到某个点
*
*  @param hidePoint 隐藏点
*  @param frame     截屏大小
*  @param view      截屏的View
*/
+ (void)showScreenshotInHidePoint:(CGPoint)hidePoint
                 screenshotRect:(CGRect)frame
                   screenshotView:(UIView *)view;

@end
