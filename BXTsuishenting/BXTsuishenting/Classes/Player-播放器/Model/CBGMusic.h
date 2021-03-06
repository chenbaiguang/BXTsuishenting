//
//  CBGOnLineMusic.h
//  test-music
//
//  Created by cbg on 16/11/10.
//  Copyright © 2016年 cbg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBGMusic : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *lrcurl;
@property (nonatomic, copy) NSString *singer;
@property (nonatomic, copy) NSString *icon;



/****** 额外的辅助属性 ******/

/** 该歌曲是否加入收藏 */
@property (nonatomic, assign, getter=isLoveMusic) BOOL loveMusic;

@end
