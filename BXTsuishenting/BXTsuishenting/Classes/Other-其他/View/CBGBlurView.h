//
//  CBGBlurView.h
//  BXTsuishenting
//
//  Created by cbg on 17/3/2.
//  Copyright © 2017年 cbg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBGBlurView : NSObject   

/**
 *  展示毛玻璃
 *
 *  @param view 模糊哪个 view
 */
+ (void)show:(UIView *)view;

+ (void)hide;

@end
