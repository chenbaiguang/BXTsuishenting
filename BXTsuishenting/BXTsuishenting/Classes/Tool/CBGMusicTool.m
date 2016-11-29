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

static NSArray *_musics;
static CBGMusic *_playingMusic;

+ (void)initialize
{
    if (_musics == nil) {
        _musics = [CBGMusic mj_objectArrayWithFilename:@"songName.plist"];
    }
    
    if (_playingMusic == nil) {
        _playingMusic = _musics[0];
    }
}

+ (NSArray *)musics
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
