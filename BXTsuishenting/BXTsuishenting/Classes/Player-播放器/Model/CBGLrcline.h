//
//  CBGLrcline.h
//  BXTsuishenting
//
//  Created by cbg on 17/02/23.
//  Copyright © 2017年 cbg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBGLrcline : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSTimeInterval time;

- (instancetype)initWithLrclineString:(NSString *)lrclineString;
+ (instancetype)lrcLineWithLrclineString:(NSString *)lrclineString;

@end
