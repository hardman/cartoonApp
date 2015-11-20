//
//  ViewController.m
//  cartoonApp
//
//  Created by kaso on 19/11/15.
//  Copyright © 2015年 kaso. All rights reserved.
//

#import "DownloadController.h"
#import <Masonry.h>

@interface DownloadController ()

@end

@implementation DownloadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel *label = [[UILabel alloc] init];
    label.text = @"DownloadController";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
