//
//  CBGMusicTool.m
//  test-music
//
//  Created by cbg on 16/11/29.
//  Copyright © 2016年 cbg. All rights reserved.
//

#import "CBGMusicTool.h"
#import "CBGMusic.h"
#import "MJExtension.h"

@implementation CBGMusicTool

static NSMutableArray *_musics;
static CBGMusic *_playingMusic;

+ (void)initialize
{
    if (_musics == nil) {
        _musics = [CBGMusic mj_objectArrayWithFilename:@"songName.plist"];
        NSLog(@"目前有多少:%zd",_musics.count);
    }
    
    if (_playingMusic == nil) {
        _playingMusic = _musics[0];
    }
}

+ (NSMutableArray *)musics
{
    return _musics;
}

+ (CBGMusic *)playingMusic
{
    return _playingMusic;
}

+ (void)setPlayingMusic:(CBGMusic *)playingMusic
{
    _playingMusic = playingMusic;
}

+ (CBGMusic *)nextMusic
{
    // 1.拿到当前播放歌词下标值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    // 2.取出下一首
    NSInteger nextIndex = ++currentIndex;
    if (nextIndex >= _musics.count) {
        nextIndex = 0;
    }
    CBGMusic *nextMusic = _musics[nextIndex];
    
    return nextMusic;
}

+ (void)hateMusic
{
    // 0.歌曲不能少于 5首
    if( _musics.count <= 5)
        return;
    
    // 1.拿到当前播放歌词下标值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
        
    // 2.从数组中移除当前歌词下标值
    [_musics removeObjectAtIndex:currentIndex];
        
    // 3.修改播放歌曲下标值
    if(currentIndex == 0)
        _playingMusic = 0;
    else
        _playingMusic = _musics[--currentIndex];
}

+ (CBGMusic *)previousMusic
{
    // 1.拿到当前播放歌词下标值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    // 2.取出下一首
    NSInteger previousIndex = --currentIndex;
    if (previousIndex < 0) {
        previousIndex = _musics.count - 1;
    }
    CBGMusic *previousMusic = _musics[previousIndex];
    
    return previousMusic;
}

@end
