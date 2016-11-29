//
//  CBGPlayMusicTool.m
//  test-music
//
//  Created by cbg on 16/11/29.
//  Copyright © 2016年 cbg. All rights reserved.
//

#import "CBGPlayMusicTool.h"

static CBGPlayMusicTool *player;

@interface CBGPlayMusicTool()

/** 当前item  */
@property (nonatomic, strong) AVPlayerItem *currentItem;

@end


@implementation CBGPlayMusicTool

#pragma mark ============================ 单例初始化播放器 ============================

+ (instancetype)sharedPlayMusicTool
{
    static dispatch_once_t once_Token;
    dispatch_once(&once_Token, ^{
        
        player = [[CBGPlayMusicTool alloc] init];
    });
    return player;
}

#pragma mark -- 初始化方法(仅运行一次)
- (id)init
{
    self = [super init];
    if (self)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.player = [AVPlayer playerWithPlayerItem:self.currentItem];
            self.player.volume = 0.5;
        });
        isPlaying = NO;
    }
    return self;
}


#pragma mark ============================ 播放/暂停音乐的方法 ============================
#pragma mark -- 播放音乐
- (void)playCurrentMusic
{
    if (isPlaying)
    {
        return;
    }
    if (!isPlaying)
    {
        [self.player replaceCurrentItemWithPlayerItem:self.currentItem];
        [self.player play];
        isPlaying = YES;
    }
}

#pragma mark -- 暂停音乐
- (void)pauseCurrentMusic
{
    if (isPlaying)
    {
        [self.player pause];
        isPlaying = NO;
        return;
    }
    if (!isPlaying)
    {
        return;
    }
}


#pragma mark ============================ 切换歌曲 ============================

- (void)playMusicWithURL:(NSString *)urlString
{
    self.currentItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
    [self.player replaceCurrentItemWithPlayerItem:self.currentItem];
    [self.player play];
    isPlaying = YES;
}


@end
