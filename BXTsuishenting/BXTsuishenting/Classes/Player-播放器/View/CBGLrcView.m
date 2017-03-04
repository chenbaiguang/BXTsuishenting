//
//  CBGLrcView.m
//  BXTsuishenting
//
//  Created by cbg on 17/02/20.
//  Copyright © 2017年 cbg. All rights reserved.
//

#import "CBGLrcView.h"
#import "CBGLrcCell.h"
#import "CBGLrcTool.h"
#import "CBGLrcline.h"
#import "CBGLrcLabel.h"
#import <MediaPlayer/MediaPlayer.h>

@interface  CBGLrcView()<UITableViewDelegate,UITableViewDataSource>


/** tableView */
@property (nonatomic, strong) UITableView *lrcView;

/** 歌词的数据 */
@property (nonatomic, strong) NSArray *lrclist;

/** 当前播放的歌词的下标 */
@property (nonatomic, assign) NSInteger currentIndex;

/** 歌名 label */
@property (strong, nonatomic) UILabel *songLabel;

/** 歌手 label */
@property (strong, nonatomic) UILabel *singerLabel;

/** headerView */
@property (strong, nonatomic) UIView *headerView;

/** 记录歌名 */
@property (copy, nonatomic) NSString *songString;

@end

@implementation CBGLrcView


#pragma mark ============================ 初始化 ============================

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupTableView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTableView];
    }
    return self;
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = (30 * kScreenHeightScale);
    [self addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate   = self;
    tableView.scrollEnabled = NO;
    self.lrcView = tableView;
    
    // tableView 的头部
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CBGScreenWidth, 90 * kScreenHeightScale)];
    self.headerView .backgroundColor = [UIColor whiteColor];
    
    self.songLabel = [[UILabel alloc] init];
    self.songLabel.font = [UIFont systemFontOfSize:(26.0f * kScreenHeightScale) ];
    self.songLabel.textColor = [UIColor blackColor];
    self.songLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView  addSubview:self.songLabel];
    
    self.singerLabel = [[UILabel alloc] init];
    self.singerLabel.font = [UIFont systemFontOfSize: (20.0f * kScreenHeightScale)];
    self.singerLabel.textColor = CBGRGBColor(128, 128, 128, 1);
    self.singerLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView  addSubview:self.singerLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.lrcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [self.songLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10 * kScreenHeightScale);
        make.left.equalTo(0);
        make.width.equalTo(CBGScreenWidth);
        make.height.equalTo(30 * kScreenHeightScale);
    }];
    
    [self.singerLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.songLabel.bottom);
        make.left.equalTo(0);
        make.width.equalTo(CBGScreenWidth);
        make.height.equalTo(30 * kScreenHeightScale);
    }];
}

#pragma mark ============================ tabelView 代理 ============================

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (90 * kScreenHeightScale);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  self.headerView ;
}

#pragma mark - 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 防止 tabelView.y 不对
    if(self.lrclist.count == 0)
    {
        return 10;
    }else{
        return self.lrclist.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建Cell
    CBGLrcCell *cell = [CBGLrcCell lrcCellWithTableView:tableView];
    
    // 2.清空复用 cell 颜色
    if (self.currentIndex != indexPath.row)
        cell.lrcLabel.progress = 0;
    
    // 3.给cell设置数据
    if(self.lrclist.count != 0)
    {
        // 3.1.取出模型
        CBGLrcline *lrcline = self.lrclist[indexPath.row];
        
        // 3.2.给cell设置数据
        cell.lrcLabel.text = lrcline.text;
        cell.lrcLabel.textColor = [UIColor blackColor];

    }else{
        if(indexPath.row == 2){
            cell.lrcLabel.text = @"歌词还没找到";
            cell.lrcLabel.textColor = CBGRGBColor(128, 128, 128, 0.5);
        }else{
            cell.lrcLabel.text = @"   ";
        }
    }
    
    return cell;
}


#pragma mark ============================ 重写 set 方法 ============================

- (void)setSongName:(NSString *)songName
{
    _songName = [songName copy];
    
    self.songLabel.text = _songName;
    
    
}

- (void)setSingerName:(NSString *)singerName
{
    _singerName = [singerName copy];
    
    self.singerLabel.text = _singerName;
}

- (void)setLrcName:(NSString *)lrcName
{
    // 切换歌词后，tabel 回滚顶部
    CGPoint offset = self.lrcView.contentOffset;
    offset.y = -self.lrcView.contentInset.top;
    [self.lrcView setContentOffset:offset animated:YES];
    
    // 0.重置保存的当前位置的下标
    self.currentIndex = 0;
    
    // 1.保存歌词名称
    _lrcName = [lrcName copy];
    
    // 2.解析歌词
    if(!NULLString(_lrcName))
        self.lrclist = [CBGLrcTool lrcToolWithLrcName:lrcName];
    else
        self.lrclist = nil;
    
    // 3.刷新表格
    [self.lrcView reloadData];
}

#pragma mark - 重写setCurrentTime方法
- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    
    // 更新锁屏界面信息
    [self setupLockScreenInfoWithLockImage:self.lockImage];
    
    // 用当前时间和歌词进行匹配
    if(self.lrclist.count != 0){
        NSInteger count = self.lrclist.count;
        for (int i = 0; i < count; i++) {
            // 1.拿到i位置的歌词
            CBGLrcline *currentLrcLine = self.lrclist[i];
        
            // 2.拿到下一句的歌词
            NSInteger nextIndex = i + 1;
            CBGLrcline *nextLrcLine = nil;
            if (nextIndex < count) {
                nextLrcLine = self.lrclist[nextIndex];
            }
        
            // 3.用当前的时间和i位置的歌词比较,并且和下一句比较,如果大于i位置的时间,并且小于下一句歌词的时间,那么显示当前的歌词
            if (self.currentIndex != i && currentTime >= currentLrcLine.time && currentTime < nextLrcLine.time) {
            
                // 3.1.获取需要刷新的行号
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            
                // 3.2.记录当前i的行号
                self.currentIndex = i;
            
                // 3.3.刷新当前的行,和上一行
                [self.lrcView reloadRowsAtIndexPaths:@[indexPath, previousIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
                // 3.4.显示对应句的歌词
                [self.lrcView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        
            // 4.根据进度,显示label画多少
            if (self.currentIndex == i) {
                // 4.1.拿到i位置的cell
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                CBGLrcCell *cell = (CBGLrcCell *)[self.lrcView cellForRowAtIndexPath:indexPath];
            
                // 4.2.更新label的进度
                CGFloat progress = (currentTime - currentLrcLine.time) / (nextLrcLine.time - currentLrcLine.time);
                cell.lrcLabel.progress = progress;
            }
        }
    }
    
}

#pragma mark ============================ 锁屏界面中心 ============================

- (void)setupLockScreenInfoWithLockImage:(UIImage *)lockImage
{

    // 不是同一首歌曲,更新锁屏界面
    if(![self.songString isEqualToString:self.songName]){
        
    // 1.获取锁屏界面中心
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    // 2.设置展示的信息
    NSMutableDictionary *playingInfo = [NSMutableDictionary dictionary];
    [playingInfo setObject:self.songName forKey:MPMediaItemPropertyAlbumTitle];
    [playingInfo setObject:self.singerName forKey:MPMediaItemPropertyArtist];
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:lockImage];
    [playingInfo setObject:artWork forKey:MPMediaItemPropertyArtwork];
    [playingInfo setObject:@(self.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    // 锁屏界面上进度条效对
    [playingInfo setObject:@(self.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    playingInfoCenter.nowPlayingInfo = playingInfo;
    
    // 3.让应用程序可以接受远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
    // 4.更新当前播放歌名
    self.songString = self.songName;}
}

@end
