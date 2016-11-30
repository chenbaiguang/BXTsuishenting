//
//  CBGPlayerViewController.m
//  BXTsuishenting
//
//  Created by cbg on 16/11/29.
//  Copyright © 2016年 cbg. All rights reserved.
//

#import "CBGPlayerViewController.h"


@interface CBGPlayerViewController ()

/** 不心疼随身听 label */
@property (strong, nonatomic) UILabel *bxtLabel;

/** 更多 Button */
@property (strong, nonatomic) UIButton *moreBtn;

/** 喜欢／讨厌／下一首 按钮的 View */
@property (strong, nonatomic) UIView *loveHateNextView;

/** 喜欢 Button */
@property (strong, nonatomic) UIButton *loveBtn;

/** 讨厌 Button */
@property (strong, nonatomic) UIButton *hateBtn;

/** 下一首 Button */
@property (strong, nonatomic) UIButton *nextBtn;

@end


@implementation CBGPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];

}

#pragma mark ============================ 布局子控件 ============================

- (void)setup
{
    // 不心疼随身听 label
    self.bxtLabel = [[UILabel alloc] init];
    self.bxtLabel.text = @"不心疼随身听";
    self.bxtLabel.font = [UIFont systemFontOfSize:24];
    self.bxtLabel.backgroundColor = CBGGreenColor;
    self.bxtLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview: self.bxtLabel];
    
    // 更多 button
    self.moreBtn = [[UIButton alloc] init];
    [self.moreBtn setTitle:@"..." forState:UIControlStateNormal];
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [self.moreBtn setTitleColor:CBGGreenColor forState:UIControlStateNormal];
    [self.view addSubview: self.moreBtn];
    
    // 喜欢／讨厌／下一首 按钮的 View
    self.loveHateNextView = [[UIView alloc] init];
    self.loveHateNextView.backgroundColor = CBGGreenColor;
    [self.view addSubview: self.loveHateNextView];
    
    // 喜欢 button
    self.loveBtn = [[UIButton alloc] init];
    [self.loveBtn setBackgroundImage:[UIImage imageNamed:@"btn_heart"] forState:UIControlStateNormal];
    [self.loveHateNextView addSubview: self.loveBtn];
    
    // 讨厌 button
    self.hateBtn = [[UIButton alloc] init];
    [self.hateBtn setBackgroundImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
    [self.loveHateNextView addSubview: self.hateBtn];
    
    // 下一首 button
    self.nextBtn = [[UIButton alloc] init];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
    [self.loveHateNextView addSubview: self.nextBtn];
}

#pragma mark - 布局子控件 frame
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // 不心疼随身听 label
    [self.bxtLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo((CBGAppStatusBarHeight + 30) * kScreenHeightScale);
        make.left.right.equalTo(0);
        make.height.equalTo(50 * kScreenHeightScale);
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
        make.height.equalTo(CBGScreenHeight/4);
    }];
    
    // 喜欢 button
    [self.loveBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.loveHateNextView);
        make.centerX.equalTo(self.loveHateNextView).dividedBy(2);
        make.width.equalTo(70 / 2);
        make.height.equalTo(72 / 2);
    }];
    
    // 讨厌 button
    [self.hateBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.loveHateNextView);
        make.centerX.equalTo(self.loveHateNextView);
        make.width.equalTo(68 / 2);
        make.height.equalTo(70 / 2);
    }];
    
    // 下一首 button
    [self.nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.loveHateNextView);
        make.centerX.equalTo(self.loveBtn).multipliedBy(3);
        make.width.equalTo(68 / 2);
        make.height.equalTo(68 / 2);
    }];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
