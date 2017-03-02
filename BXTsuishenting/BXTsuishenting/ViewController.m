//
//  ViewController.m
//  BXTsuishenting
//
//  Created by cbg on 16/11/29.
//  Copyright © 2016年 cbg. All rights reserved.
//

#import "ViewController.h"
#import "CBGPlayerViewController.h"


@interface ViewController ()
@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CBGPlayerViewController *playerViewController = [[CBGPlayerViewController alloc] init];
    
    [self.view addSubview:playerViewController.view];
    [self addChildViewController:playerViewController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

@end
