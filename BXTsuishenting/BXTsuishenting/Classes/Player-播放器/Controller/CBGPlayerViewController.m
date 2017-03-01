//
//  CBGPlayerViewController.m
//  BXTsuishenting
//
//  Created by cbg on 16/11/29.
//  Copyright © 2016年 cbg. All rights reserved.
//

#import "CBGPlayerViewController.h"
#import "DACircularProgressView.h"
#import "CBGLrcView.h"
#import "CBGAnimationView.h"
#import "CBGLoveMusicView.h"
#import "UIImageView+WebCache.h"


#import "CBGLoveMusicCell.h"


@interface CBGPlayerViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

/** 不心疼随身听 label */
@property (strong, nonatomic) UILabel *bxtLabel;

/** 更多 Button */
@property (strong, nonatomic) UIButton *moreBtn;

/** 喜欢歌曲 View */
@property (strong, nonatomic) CBGLoveMusicView *loveMusicView;

/** 圆形进度条 */
@property (strong, nonatomic) DACircularProgressView *progressView;

/** 圆形按钮 */
@property (strong, nonatomic) UIButton *circularBtn;

/** 播放 imageView 图片 */
@property (strong, nonatomic) UIImageView *playImageView;

/** 圆形按钮宽度 */
@property (assign, nonatomic) CGFloat circularBtnWidth;

/** 喜欢／讨厌／下一首 按钮的 View */
@property (strong, nonatomic) UIView *loveHateNextView;

/** 喜欢 Button */
@property (strong, nonatomic) UIButton *loveBtn;

/** 讨厌 Button */
@property (strong, nonatomic) UIButton *hateBtn;

/** 下一首 Button */
@property (strong, nonatomic) UIButton *nextBtn;

/** 歌词 view */
@property (strong, nonatomic) CBGLrcView *lrcView;

/** 音乐播放器单列 */
@property (strong, nonatomic) CBGPlayMusicTool *playMusicTool;

/** 歌曲是否播放 */
@property (assign, nonatomic) BOOL isPlaying;

/** 歌曲是否喜欢 */
@property (assign, nonatomic) BOOL isLoveMusic;

/** 进度的Timer */
@property (strong, nonatomic) NSTimer *progressTimer;

/** 歌词更新的定时器 */
@property (strong, nonatomic) CADisplayLink *lrcTimer;

/** 当前音乐已播放时间 */
@property (assign, nonatomic) CGFloat currentTime;

/** 当前音乐总播放时间 */
@property (assign, nonatomic) CGFloat totalTime;

/** 网络请求 */
@property (strong, nonatomic) AFHTTPSessionManager *afnManager;

/** 网络监测 */
@property (strong, nonatomic) AFNetworkReachabilityManager *manager;


@end


@implementation CBGPlayerViewController

#pragma mark ============================ 初始化 ============================

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0.初始化
    self.view.backgroundColor = [UIColor whiteColor];
    self.playMusicTool = [CBGPlayMusicTool sharedPlayMusicTool];
    self.afnManager = [AFHTTPSessionManager manager];
    self.manager= [AFNetworkReachabilityManager manager];
    
    // 1.设置界面UI
    [self setup];
    
    // 2.开始网络监测
    [self.manager startMonitoring];
    
    // 3.监测网络状态
    [self afnNetwork];
}
#pragma mark ============================ 网络状态监测 ============================

- (void)afnNetwork
{
    __weak typeof(self) weakSelf = self;
    
    // 网络状态发生变化会进入 Block
    [self.manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        // 1.有网络情况下，已经播放过歌曲
        if(weakSelf.playMusicTool.player.currentItem)
        {
            // 1.1.网络突然断开
            if(noNetwork){
                weakSelf.isPlaying = NO;}
            // 1.2.网络连接上
            else{
                weakSelf.isPlaying = YES;}
            
            // 1.3.更新播放信息
            [weakSelf setAlphaImage];
        }
        
        
        // 2.刚开始开始进入程序，有网并且没有歌曲在播放，仅执行一次
        if(status == 1 || status == 2)
            if(!weakSelf.playMusicTool.player.currentItem)
                [weakSelf startPlayingMusic];
    }] ;
    
}

#pragma mark ============================ 开始播放音乐 ============================

- (void)startPlayingMusic
{
    // 1.取出当前播放歌曲
    CBGMusic *playingMusic = [CBGMusicTool playingMusic];
    
    if(NULLString(playingMusic.icon)){
        [self.circularBtn setImage:nil forState:UIControlStateNormal];
    }else{
        // 2.设置界面信息
        [self.circularBtn.imageView sd_setImageWithURL:[NSURL URLWithString:playingMusic.icon]
                                  placeholderImage:[UIImage imageNamed:@"noArt"]
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        [self.circularBtn setImage:image forState:UIControlStateNormal];
                                             self.lrcView.lockImage = image;
//        switch (cacheType) {
//                    case SDImageCacheTypeNone:
//                        NSLog(@"直接下载");
//                        break;
//                    case SDImageCacheTypeDisk:
//                        NSLog(@"磁盘缓存");
//                        break;
//                    case SDImageCacheTypeMemory:
//                        NSLog(@"内存缓存");
//                        break;
//                    default:
//                        break;
//                }
        }];
    }
    
    self.lrcView.songName = playingMusic.name;
    self.lrcView.singerName = playingMusic.singer;

    // 3.开始播放歌曲
    [self.playMusicTool playMusicWithURL:playingMusic.url];
    self.isPlaying = YES;
    
    // 4.设置歌词
    if(!NULLString(playingMusic.lrcurl)){
        // 直接使用“服务器本来返回的数据”，不做任何解析
        _afnManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_afnManager GET:playingMusic.lrcurl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        NSString *lrcString =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        self.lrcView.lrcName = lrcString;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败---%@", error);
        }];
    }else{
        self.lrcView.lrcName = @"    ";
    }
    
    self.totalTime = CMTimeGetSeconds(self.playMusicTool.player.currentItem.asset.duration);
    self.lrcView.duration = self.totalTime;
    
    // 5.添加定时器用户更新进度界面
    [self removeProgressTimer];
    [self addProgressTimer];
    [self removeLrcTimer];
    [self addLrcTimer];
    
    // 6.添加通知，监听歌曲播放完毕
    [CBGNoteCenter addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playMusicTool.player.currentItem];
    
    // 7.更新界面透明度和按钮图片
    [self setAlphaImage];
    
    // 8.更新爱心按钮图片
    [self setLoveBtnImage:playingMusic.loveMusic];
}

#pragma mark ============================ 通知－歌曲播完完毕 ============================


- (void)playbackFinished{
    [self nextMusic];
}

#pragma mark ============================ 定时器处理 ============================

- (void)addProgressTimer
{
    [self updateProgressInfo];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)addLrcTimer
{
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}

#pragma mark - 更新进度的界面
- (void)updateProgressInfo
{
    // 1.设置当前的播放时间
    self.currentTime = CMTimeGetSeconds(self.playMusicTool.player.currentTime);
    
//    NSLog(@"%f ----  %f",self.currentTime,self.totalTime);
    
    // 2.更新进度条
    self.progressView.progress = self.currentTime / self.totalTime;
}

#pragma mark - 更新歌词的界面
- (void)updateLrc
{
    self.lrcView.currentTime = self.currentTime;
}

#pragma mark ============================ 按钮事件处理 ============================

- (void)likeSongsView
{
    if(noNetwork){
        NSLog(@"网络出现问题啦～看不了喜欢歌曲");
        return;
    }
    
    // 1.loveMusicView Y值
    CGFloat y = self.progressView.frame.origin.y + self.progressView.frame.size.height + (20 * kScreenHeightScale);
    
    // 2.喜欢歌曲 view 动画显示
    if(self.loveMusicView == nil){
        // 2.1.初始化 loveMusicView
        self.loveMusicView = [[CBGLoveMusicView alloc] init];
        self.loveMusicView.frame = CGRectMake(0, y , CBGScreenWidth, CBGScreenHeight - y);
        [self.view addSubview:_loveMusicView];
        self.loveMusicView.transform = CGAffineTransformMakeTranslation(0, CBGScreenHeight - y);
    
        // 2.2.清空形变，模仿 modal 效果
        [UIView animateWithDuration:0.3 animations:^{
            self.loveMusicView.transform = CGAffineTransformIdentity;
            
            //  2.3.设置背景颜色
            self.view.backgroundColor = CBGRGBColor(1, 1, 1, 0.4);
        }];
        
        // 2.4.设置 tableView代理
        self.loveMusicView.loveMusicTable.delegate = self;
        self.loveMusicView.loveMusicTable.dataSource = self;
    }
    
    // 3.添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    // 轻拍次数
    tap.numberOfTapsRequired =1;
    // 轻拍手指个数
    tap.numberOfTouchesRequired =1;
    [self.view addGestureRecognizer:tap];
}

- (void)playOrPause
{
    if(noNetwork){
        NSLog(@"网络出现问题啦～播放不了歌曲");
        return;
    }
    
    // 0.标记取反
    self.isPlaying = !self.isPlaying;
    
    // 1.设置透明度和按钮图片
    [self setAlphaImage];
}

- (void)setAlphaImage
{
    // 1.设置圆形按钮／歌词view 透明度
    CGFloat alphaValue;
    alphaValue = self.isPlaying == 0 ? 0.3:1;
    self.circularBtn.alpha = alphaValue;
    self.lrcView.alpha = alphaValue;
    
    // 2.设置播放 imageView 的图片
    UIImage *image;
    image = self.isPlaying == 0 ? [UIImage imageNamed:@"btn_play" ] : nil;
    self.playImageView.image = image;
    
    // 3.播放／暂停歌曲
    // 4.开始／暂停定时器
    if(self.isPlaying){
        [self.playMusicTool playCurrentMusic];
        [self addProgressTimer];
        [self addLrcTimer];
    }else{
        [self.playMusicTool pauseCurrentMusic];
        [self removeProgressTimer];
        [self removeLrcTimer];
    }
}

- (void)loveMusic
{
    if(noNetwork){
        NSLog(@"网络出现问题啦～收藏不了歌曲");
        return;
    }
    
    // 0.获取当前歌曲上一次标记
    CBGMusic *playingMusic = [CBGMusicTool playingMusic];
    
    // 2.标记取反
    playingMusic.loveMusic = !playingMusic.loveMusic;
    
    // 3.设置爱心按钮的图片
    [self setLoveBtnImage:playingMusic.loveMusic];
    
    // 4.将当前的歌曲添加／删除 MusicTool 数组中
    [CBGMusicTool setLoveMusics];

}

- (void)setLoveBtnImage:(BOOL)loveMusic
{
    UIImage *image;
    image = loveMusic == 0 ? [UIImage imageNamed:@"btn_heart"] : [UIImage imageNamed:@"btn_heart_red"];
    [self.loveBtn setImage:image forState:UIControlStateNormal];
}

- (void)hateMusic
{
    if(noNetwork){
        NSLog(@"网络出现问题啦～删除不了歌曲");
        return;
    }
    
    // 0.歌曲不能少于 5首
    if([CBGMusicTool musics].count <= 5)
        return;
    
    // 1.动画删除效果
    // 1.1.隐藏点
    CGPoint hidePoint = CGPointMake(CBGScreenWidth /2 , self.loveHateNextView.y + self.hateBtn.y);
    // 1.2截屏大小
    CGRect  screenshotRect = CGRectMake(0, 0, CBGScreenWidth, CBGScreenHeight - self.loveHateNextView.frame.size.height);
    
    [CBGAnimationView showScreenshotInHidePoint:hidePoint
                                 screenshotRect:screenshotRect
                                 screenshotView:self.view ];
    
    // 2.先判断当前歌曲是否喜欢
    CBGMusic *playingMusic = [CBGMusicTool playingMusic];
    if(playingMusic.loveMusic){
        playingMusic.loveMusic = NO;
        [CBGMusicTool setLoveMusics];
    }
    
    // 3.把当前歌曲从 plist 列表中删除
    [CBGMusicTool hateMusic];
    
    // 4.切换下一首歌曲
    [self nextMusic];
}

- (void)nextMusic
{
    if(noNetwork){
        NSLog(@"网络出现问题啦～切换不了歌曲");
        return;
    }
    
    // 0.移除播放完毕观察者
    [CBGNoteCenter removeObserver:self];
    
    // 1.取出下一首播放歌曲
    CBGMusic *nextMusic = [CBGMusicTool nextMusic];
    
    // 2.修改当前播放歌曲
    [CBGMusicTool setPlayingMusic: nextMusic];
    
    // 3.开始播放歌曲
    [self startPlayingMusic];
}

#pragma mark ============================ loveMusicView 代理方法 ============================

#pragma mark - 数据源代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CBGMusicTool loveMusics].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建 cell
    CBGLoveMusicCell *cell = [CBGLoveMusicCell loveMusicCellWithTableView:self.loveMusicView.loveMusicTable];
        
    // 2.取出模型数据
    CBGMusic *cellMusic = [CBGMusicTool loveMusics][indexPath.row];
    CBGMusic *playignMusic = [CBGMusicTool playingMusic];
    
    // 3.设置 cell数据
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",cellMusic.name,cellMusic.singer];
    cell.textLabel.font = [UIFont systemFontOfSize:(16.0 * kScreenHeightScale)];

    
    // 4.处理每个 cell上的按钮事件
    __weak typeof(self) weakSelf = self;
    cell.btnClick = ^(){

        // 4.1.点击移除歌曲是正在播放的，就更新当前页面
        if(cellMusic == playignMusic)
            [weakSelf setLoveBtnImage:NO];
        
        // 4.2.移除这一行喜欢的歌曲
        cellMusic.loveMusic = NO;
        [CBGMusicTool removeLoveMusics:cellMusic];
        
        // 4.3.删除这一行 cell,刷新表格
        [weakSelf.loveMusicView.loveMusicTable reloadData];
    };
    
    return cell;
}

#pragma mark - 监听事件代理


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 0.移除播放完毕观察者
    [CBGNoteCenter removeObserver:self];
    
    // 1.取出喜欢的歌曲
    CBGMusic *loveMusic = [CBGMusicTool loveMusics][indexPath.row];
    
    // 2.修改当前播放歌曲
    [CBGMusicTool setPlayingMusic: loveMusic];
    
    // 3.开始播放歌曲
    [self startPlayingMusic];
    
    // 4. loveMusicView 消失
    [self tap:nil];
}

#pragma mark ============================ 手势处理 ============================
#pragma mark - 手势点击
- (void)tap:(UITapGestureRecognizer *)tap
{
    
    CGFloat y = self.progressView.frame.origin.y + self.progressView.frame.size.height + (20 * kScreenHeightScale);
    
    // 0.移除手势
    [self.view removeGestureRecognizer:tap];
    
    // 1. loveMusicView 动画效果下滑移出
    [UIView animateWithDuration:1 animations:^{
        self.loveMusicView.transform = CGAffineTransformMakeTranslation(0, CBGScreenHeight - y);
    } completion:^(BOOL finished) {
        [self.loveMusicView removeFromSuperview];
        self.loveMusicView = nil;
    }];
    
    // 2.设置界面透明度
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 手势范围
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 1.获取当前点击的点
    CGPoint curP = [touch locationInView:self.view];
    
    // 2.设置 Y 值最大可点击范围
    CGFloat maxY = self.loveMusicView.y;
    
    // 3.设置点击事件处理范围
    if(curP.y < maxY)
        return YES;
    else
        return NO;
}

#pragma mark ============================ 远程事件(后台处理) ============================

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self playOrPause];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextMusic];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
//            [self previous];
            break;
            
        default:
            break;
    }
}

#pragma mark ============================ 布局子控件 ============================

- (void)setup
{
    // 不心疼随身听 label
    self.bxtLabel = [[UILabel alloc] init];
    self.bxtLabel.text = @"不心疼随身听";
    self.bxtLabel.textColor = CBGGreenColor;
    self.bxtLabel.font = [UIFont systemFontOfSize:(28 * kScreenHeightScale)];
    self.bxtLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview: self.bxtLabel];
    
    // 更多 button
    self.moreBtn = [[UIButton alloc] init];
    [self.moreBtn setTitle:@"..." forState:UIControlStateNormal];
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [self.moreBtn setTitleColor:CBGGreenColor forState:UIControlStateNormal];
    [self.moreBtn addTarget:self action:@selector(likeSongsView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.moreBtn];
    
    // 圆形进度条
    self.progressView = [[DACircularProgressView alloc] init];
    self.progressView.roundedCorners = YES;
    self.progressView.trackTintColor = CBGRGBColor(137, 203, 149, 0.5);
    self.progressView.progressTintColor = CBGGreenColor;
    self.progressView.thicknessRatio = (0.08 * kScreenHeightScale);
    [self.view addSubview:self.progressView];
    
    self.circularBtnWidth = CBGProgressWidth  * (1.0f - self.progressView.thicknessRatio);
    
    // 圆形按钮
    self.circularBtn = [[UIButton alloc] init];
    self.circularBtn.layer.cornerRadius = (self.circularBtnWidth * kScreenHeightScale) / 2;
    self.circularBtn.clipsToBounds = YES;
    self.circularBtn.adjustsImageWhenHighlighted = NO;
    [self.circularBtn setBackgroundImage: [UIImage imageNamed:@"noArt"] forState:UIControlStateNormal];
    [self.circularBtn addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
    [self.progressView addSubview:self.circularBtn];
    
    // 播放 imageView 的图片
    self.playImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.playImageView];
    
    // 喜欢／讨厌／下一首 按钮的 View
    self.loveHateNextView = [[UIView alloc] init];
    [self.view addSubview: self.loveHateNextView];
    
    // 喜欢 button
    self.loveBtn = [[UIButton alloc] init];
    [self.loveBtn setBackgroundImage:[UIImage imageNamed:@"btn_heart"] forState:UIControlStateNormal];
    [self.loveBtn addTarget:self action:@selector(loveMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.loveHateNextView addSubview: self.loveBtn];
    
    // 讨厌 button
    self.hateBtn = [[UIButton alloc] init];
    [self.hateBtn setBackgroundImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
    [self.hateBtn addTarget:self action:@selector(hateMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.loveHateNextView addSubview: self.hateBtn];
    
    // 下一首 button
    self.nextBtn = [[UIButton alloc] init];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(nextMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.loveHateNextView addSubview: self.nextBtn];
    
    self.lrcView = [[CBGLrcView alloc] init];
    self.lrcView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.lrcView];
    
}

#pragma mark - 布局子控件 frame
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // 不心疼随身听 label
    [self.bxtLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo((CBGAppStatusBarHeight + 30) * kScreenHeightScale);
        make.left.right.equalTo(0);
        make.height.equalTo(30 * kScreenHeightScale);
    }];
    
    // 圆形进度条
    [self.progressView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.bxtLabel.bottom).offset(20 * kScreenHeightScale);
        make.width.height.equalTo(CBGProgressWidth * kScreenHeightScale);
    }];
    
    // 圆形按钮
    [self.circularBtn makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.progressView);
        make.width.height.equalTo(self.circularBtnWidth * kScreenHeightScale);
    }];
    
    // 播放 imageView 的图片
    [self.playImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressView);
        make.centerX.equalTo(self.progressView).offset(5 * kScreenWidthScale);
        make.width.equalTo(70 / 2);
        make.height.equalTo(86 / 2);
    }];
    
    // 更多 button
    [self.moreBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bxtLabel.top);
        make.right.equalTo(0);
        make.top.equalTo(CBGAppStatusBarHeight);
        make.width.equalTo(30 * kScreenWidthScale);
    }];
    
    // 喜欢／讨厌／下一首 按钮的 View
    [self.loveHateNextView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(CBGScreenHeight/6);
    }];
    
    // 喜欢 button
    [self.loveBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.loveHateNextView).offset(-15 * kScreenHeightScale);
        make.centerX.equalTo(self.loveHateNextView).dividedBy(2);
        make.width.equalTo(70 / 2);
        make.height.equalTo(72 / 2);
    }];
    
    // 讨厌 button
    [self.hateBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loveBtn);
        make.centerX.equalTo(self.loveHateNextView);
        make.width.equalTo(68 / 2);
        make.height.equalTo(70 / 2);
    }];
    
    // 下一首 button
    [self.nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loveBtn);
        make.centerX.equalTo(self.loveBtn).multipliedBy(3);
        make.width.equalTo(68 / 2);
        make.height.equalTo(68 / 2);
    }];
    
    // 歌词 view
    [self.lrcView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(CBGScreenWidth);
        make.top.equalTo(self.progressView.bottom).offset(20 * kScreenHeightScale);
        make.bottom.equalTo(self.loveHateNextView.top).offset(-20 * kScreenHeightScale);
    }];
    
}

@end
