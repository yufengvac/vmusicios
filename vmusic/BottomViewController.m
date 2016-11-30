//
//  BottomViewController.m
//  vmusic
//
//  Created by feng yu on 16/11/30.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "BottomViewController.h"
#define screenWidth  [[UIScreen mainScreen]bounds].size.width

#define screenHeight  [[UIScreen mainScreen]bounds].size.height
#define bottomHeight 60
@interface BottomViewController ()

@end

@implementation BottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBottomView];
}

-(void)addBottomView{
    NSInteger baseHeight = screenHeight - bottomHeight;
    NSInteger margin = 10;
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0,baseHeight, screenWidth, 0.3)];
    line.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, baseHeight, screenWidth, bottomHeight)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = 108;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    
    UIImageView *singerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(margin, margin, bottomHeight-margin*2, bottomHeight-margin*2)];
    singerImageView.layer.masksToBounds = YES;
    singerImageView.image = [UIImage imageNamed:@"default_bg"];
    singerImageView.layer.cornerRadius = (bottomHeight-margin*2)/2;
    [btn addSubview:singerImageView];
    
    NSInteger width = bottomHeight-20;
    UIButton *playBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth-width*2, 10, width, width)];
    [playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    playBtn.tag = 109;
    [playBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [btn addSubview:playBtn];
    
    UIButton *songListBtn =[[UIButton alloc]initWithFrame:CGRectMake(screenWidth-width, 10, width, width)];
    [songListBtn setImage:[UIImage imageNamed:@"icon_songlist"] forState:UIControlStateNormal];
    songListBtn.tag = 110;
    [songListBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [btn addSubview:songListBtn];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
