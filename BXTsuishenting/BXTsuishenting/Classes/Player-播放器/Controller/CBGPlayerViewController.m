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


@interface CBGPlayerViewController ()

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


@end


@implementation CBGPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0.初始化
    self.view.backgroundColor = [UIColor whiteColor];
    self.playMusicTool = [CBGPlayMusicTool sharedPlayMusicTool];
    _afnManager = [AFHTTPSessionManager manager];

    // 1.设置界面UI
    [self setup];
    
    // 2.展示界面的信息
    [self startPlayingMusic];

}

#pragma mark ============================ 开始播放音乐 ============================

- (void)startPlayingMusic
{
    // 1.取出当前播放歌曲
    CBGMusic *playingMusic = [CBGMusicTool playingMusic];
    
    if(NULLString(playingMusic.icon)){
        [self.circularBtn setBackgroundImage: [UIImage imageNamed:@"noArt"] forState:UIControlStateNormal];
    }
    else{
    // 2.设置界面信息
    [self.circularBtn.imageView sd_setImageWithURL:[NSURL URLWithString:playingMusic.icon] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        [self.circularBtn setBackgroundImage: image forState:UIControlStateNormal];
        
        switch (cacheType) {
                    case SDImageCacheTypeNone:
                        NSLog(@"直接下载");
                        break;
                    case SDImageCacheTypeDisk:
                        NSLog(@"磁盘缓存");
                        break;
                    case SDImageCacheTypeMemory:
                        NSLog(@"内存缓存");
                        break;
                    default:
                        break;
                }
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
    
    [CBGNoteCenter addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playMusicTool.player.currentItem];
    
    // 6.更新界面透明度和按钮图片
    [self setAlphaImage];
   
}

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
    // 喜欢歌曲 view 动画显示
    if(self.loveMusicView == nil){
        self.loveMusicView = [[CBGLoveMusicView alloc] init];
        self.loveMusicView.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height / 2  , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 2);
    
        [self.view addSubview:_loveMusicView];
    
        self.loveMusicView.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height / 2);
    
        [UIView animateWithDuration:0.3 animations:^{
            self.loveMusicView.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)playOrPause
{
    // 0.标记取反
    self.isPlaying = !self.isPlaying;
    
    // 1.设置透明度和按钮图片
    [self setAlphaImage];
    
    // 2.播放／暂停歌曲
    // 3.开始／暂停定时器
    
    if(self.isPlaying){
        
        [self.playMusicTool playCurrentMusic];
        [self addProgressTimer];}
    else{
        
        [self.playMusicTool pauseCurrentMusic];
        [self removeProgressTimer];
    }
    
}

- (void)setAlphaImage
{
    // 1.设置圆形按钮的图片
    CGFloat alphaValue;
    alphaValue = self.isPlaying == 0 ? 0.3:1;
    self.circularBtn.alpha = alphaValue;
    self.lrcView.alpha = alphaValue;
    
    // 2.圆形按钮／歌词view 透明度
    UIImage *image;
    image = self.isPlaying == 0 ? [UIImage imageNamed:@"btn_play" ] : nil;
    [self.circularBtn setImage:image forState:UIControlStateNormal];

}

- (void)loveMusic
{
    // 0.获取当前歌曲上一次标记
    // 1.设置爱心按钮的图片
    // 2.将当前的歌曲添加／删除 loveMusicView 列表
    // 3.标记取反
}

- (void)hateMusic
{
    // 0.歌曲不能少于 5首
    if([CBGMusicTool musics].count <= 5)
        return;
    
    // 1.动画删除效果
    // 隐藏点
    CGPoint hidePoint = CGPointMake(CBGScreenWidth /2 , self.loveHateNextView.y + self.hateBtn.y);
    // 截屏大小
    CGRect  screenshotRect = CGRectMake(0, 0, CBGScreenWidth, CBGScreenHeight - self.loveHateNextView.frame.size.height);
    
    [CBGAnimationView showScreenshotInHidePoint:hidePoint
                                 screenshotRect:screenshotRect
                                 screenshotView:self.view ];
    
    // 2.把当前歌曲从 plist 列表中删除
    [CBGMusicTool hateMusic];
    
    // 3.切换下一首歌曲
    [self nextMusic];
    NSLog(@"播放下一首歌曲");
}

- (void)nextMusic
{
    // 0.移除播放完毕观察者
    [CBGNoteCenter removeObserver:self];
    
    // 1.取出下一首播放歌曲
    CBGMusic *nextMusic = [CBGMusicTool nextMusic];
    
    // 2.修改当前播放歌曲
    [CBGMusicTool setPlayingMusic: nextMusic];
    
    // 3.开始播放歌曲
    [self startPlayingMusic];
    
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
    self.circularBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (-15 * kScreenWidthScale));
    [self.circularBtn addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
    [self.progressView addSubview:self.circularBtn];
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [UIView animateWithDuration:1 animations:^{
        self.loveMusicView.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height / 2);
        
    } completion:^(BOOL finished) {
        [self.loveMusicView removeFromSuperview];
        self.loveMusicView = nil;
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
