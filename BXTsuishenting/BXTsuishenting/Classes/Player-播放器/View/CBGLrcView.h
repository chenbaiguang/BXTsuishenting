//
//  CBGLrcView.h
//  BXTsuishenting
//
//  Created by cbg on 17/02/20.
//  Copyright © 2017年 cbg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBGLrcView : UIView

@property (nonatomic, copy) NSString *lrcName;

/** 当前播放的时间 */
@property (nonatomic, assign) NSTimeInterval currentTime;

/** 当前歌曲的总时长 */
@property (nonatomic, assign) NSTimeInterval duration;


@end
