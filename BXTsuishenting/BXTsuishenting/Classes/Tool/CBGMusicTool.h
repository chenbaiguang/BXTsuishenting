//
//  CBGMusicTool.h
//  test-music
//
//  Created by cbg on 16/11/29.
//  Copyright © 2016年 cbg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBGMusic;


@interface CBGMusicTool : NSObject

+ (NSArray *)musics;

+ (CBGMusic *)playingMusic;

+ (void)setPlayingMusic:(CBGMusic *)playingMusic;

+ (CBGMusic *)nextMusic;

+ (CBGMusic *)previousMusic;

@end
