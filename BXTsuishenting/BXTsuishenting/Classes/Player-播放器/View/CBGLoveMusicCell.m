//
//  CBGLoveMusicCell.m
//  BXTsuishenting
//
//  Created by cbg on 17/02/20.
//  Copyright © 2017年 cbg. All rights reserved.
//

#import "CBGLoveMusicCell.h"

@implementation CBGLoveMusicCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 20 - 20,10,20 , 20);
        [btn setImage:[UIImage imageNamed:@"btn_heart_red"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(heartAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

+ (instancetype)loveMusicCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    CBGLoveMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[CBGLoveMusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}


- (void)heartAction
{
    NSLog(@"点击了爱心");
    if(self.btnClick){
        self.btnClick();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
