//
//  CBGLoveMusicView.m
//  BXTsuishenting
//
//  Created by cbg on 17/02/20.
//  Copyright © 2017年 cbg. All rights reserved.
//

#import "CBGLoveMusicView.h"
#import "CBGLoveMusicCell.h"

@interface CBGLoveMusicView()<UITableViewDelegate,UITableViewDataSource>

/** tableView */
@property (strong, nonatomic) UITableView *loveMusicView;

@end


@implementation CBGLoveMusicView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor greenColor];
        [self setupTableView];
    }
    return self;
}

- (void)setupTableView{
    
    self.loveMusicView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2) style:UITableViewStylePlain];
    self.loveMusicView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.loveMusicView.delegate = self;
    self.loveMusicView.dataSource = self;
    self.loveMusicView.rowHeight = 40;
    self.loveMusicView.bounces = NO;
    [self addSubview:self.loveMusicView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBGLoveMusicCell *cell = [CBGLoveMusicCell loveMusicCellWithTableView:self.loveMusicView];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    
    __weak typeof(cell) weakCell = cell;
    cell.btnClick = ^(){
        NSLog(@"%zd",indexPath.row);
        weakCell.backgroundColor = [UIColor redColor];
    };
    
    return cell;
}

@end
