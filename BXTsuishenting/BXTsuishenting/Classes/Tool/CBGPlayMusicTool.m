//
//  CBGPlayMusicTool.m
//  test-music
//
//  Created by cbg on 16/11/29.
//  Copyright © 2016年 cbg. All rights reserved.
//

#import "CBGPlayMusicTool.h"

// 0.提供全局变量
static CBGPlayMusicTool *_player;

@interface CBGPlayMusicTool()

/** 当前item  */
@property (nonatomic, strong) AVPlayerItem *currentItem;

@end


@implementation CBGPlayMusicTool

#pragma mark ============================ 单例初始化播放器 ============================

// 1.alloc ---> allocWithZone ( 这份资源初始化一次)
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    // 1.1.在多线程情况下访问,同一资源会有安全隐患
    // 1.2.使用互斥锁 @synchronized
//    @synchronized (self) {
//        if(player == nil){
//            player = [super allocWithZone:zone];
//        }
//    }
    
    // 1.3.使用 GCD,本身就是线程安全的
    static dispatch_once_t once_Token;
    dispatch_once(&once_Token, ^{
        
        _player = [super allocWithZone:zone];
    });
    return _player;
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


// 2.提供类方法（方便外界访问和辨识单列）
+ (instancetype)sharedPlayMusicTool
{
    return [[self alloc] init];
}


// 3.严谨起见(copy,mutableCopy)
-(id)copyWithZone:(NSZone *)zone
{
    return _player;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _player;
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
