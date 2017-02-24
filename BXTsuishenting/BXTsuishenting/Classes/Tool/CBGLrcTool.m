//
//  CBGLrcTool.m
//  BXTsuishenting
//
//  Created by cbg on 17/02/23.
//  Copyright © 2017年 cbg. All rights reserved.
//

#import "CBGLrcTool.h"
#import "CBGLrcline.h"

@implementation CBGLrcTool

+ (NSArray *)lrcToolWithLrcName:(NSString *)lrcName
{

    // 1.拿到歌词的数组
    NSArray *lrcArray = [lrcName componentsSeparatedByString:@"\n"];
    
    // 2.遍历每一句歌词,转成模型
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *lrclineString in lrcArray) {
        // 拿到每一句歌词
        /*
         [ti:心碎了无痕]
         [ar:张学友]
         [al:]
         */
        // 过滤不需要的歌词的行
        if ([lrclineString hasPrefix:@"[ti:"] || [lrclineString hasPrefix:@"[ar:"] || [lrclineString hasPrefix:@"[al:"] || ![lrclineString hasPrefix:@"["]) {
            continue;
        }
        
        // 将歌词转成模型
        CBGLrcline *lrcLine = [CBGLrcline lrcLineWithLrclineString:lrclineString];
        [tempArray addObject:lrcLine];
    }
    
    return tempArray;
}

@end
