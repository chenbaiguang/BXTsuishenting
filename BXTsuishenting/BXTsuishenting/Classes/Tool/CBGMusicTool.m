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

static NSMutableArray *_loveMusics;


+ (void)initialize
{
    if (_musics == nil)
        _musics = [CBGMusic mj_objectArrayWithFilename:@"songName.plist"];

    
    if (_playingMusic == nil)
        _playingMusic = _musics[0];
    
    if(_loveMusics == nil)
        _loveMusics = [NSMutableArray array];
}

+ (NSMutableArray *)musics
{
    return _musics;
}

+ (NSMutableArray *)loveMusics
{
    return _loveMusics;
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

+ (void)setLoveMusics
{
    // 1.判断该歌曲是否喜欢
    if(_playingMusic.loveMusic)
    {
        // 1.1.喜欢，但喜欢数组中没有这个元素
        if(![_loveMusics containsObject:_playingMusic]){
            [_loveMusics addObject:_playingMusic];
        }
    }
    else{
        // 2.不喜欢，在喜欢数组中，移除该元素
        [self removeLoveMusics: _playingMusic];
    }
}

+ (void)removeLoveMusics:(CBGMusic *)removeMusic
{
    [_loveMusics removeObject:removeMusic];
}


@end
