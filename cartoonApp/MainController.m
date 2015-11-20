//
//  ViewController.m
//  cartoonApp
//
//  Created by kaso on 19/11/15.
//  Copyright © 2015年 kaso. All rights reserved.
//

#import "MainController.h"
#import <Masonry.h>
#import "Constants.h"

@interface MainController (){
    UIScrollView * mHeadScrollView;
}
@end

@implementation MainController

- (void)setNavigation{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setNavigation];
    [self createView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"MainController";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
}

-(void)createView{
    //首先顶部滚动条
    mHeadScrollView = [[UIScrollView alloc] init];
    mHeadScrollView.delegate = self;
    mHeadScrollView.backgroundColor = COLOR(255,0,0);
    [self.view addSubview:mHeadScrollView];
    WEAKSELF;
    [mHeadScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (weakSelf) {
            make.width.equalTo(weakSelf.view);
            make.height.equalTo(@(y(200)));
        }
    }];
}

-(void)refreshView{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
