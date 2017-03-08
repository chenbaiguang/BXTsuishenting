//
//  CBGPlayMusicTool.h
//  test-music
//
//  Created by cbg on 16/11/29.
//  Copyright © 2016年 cbg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/** 播放器播放状态 */
static BOOL isPlaying;

@interface  CBGPlayMusicTool : NSObject< NSCopying, NSMutableCopying>

/** 播放器 */
@property (nonatomic, strong) AVPlayer *player;

/** 初始化单例 */
+ (instancetype)sharedPlayMusicTool;

/** 播放 */
- (void)playCurrentMusic;

/** 暂停 */
- (void)pauseCurrentMusic;

/** 根据url播放音乐 */
- (void)playMusicWithURL:(NSString *)urlString;


@end