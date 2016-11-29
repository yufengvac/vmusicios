//
//  MainViewController.m
//  vmusic
//
//  Created by feng yu on 16/11/29.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "MainViewController.h"
#import "UIColor+ColorChange.h"
#define screenWidth  [[UIScreen mainScreen]bounds].size.width
#define screenHeight  [[UIScreen mainScreen]bounds].size.height
#define statusBarHeight 15
#define padding 10
#define bottomHeight 60
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    [super viewDidLoad];
    [self addScrollView];
    [self addTopContent];
    [self addBottomView];
}

-(void)addTopContent{
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, statusBarHeight+50)];
    [bgImageView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]];
    [self.view addSubview:bgImageView];
    
    UIButton *menuBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, statusBarHeight, 50 , 50)];
    [menuBtn setImage:[UIImage imageNamed:@"main_head_left_menu"] forState:UIControlStateNormal];
    [self.view addSubview:menuBtn];
    
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth-50, statusBarHeight, 50, 50)];
    [searchBtn setImage:[UIImage imageNamed:@"main_head_right_search"] forState:UIControlStateNormal];
    [self.view addSubview:searchBtn];
    
    UIButton *localMusicBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth/2-70, statusBarHeight, 60, 50)];
    [localMusicBtn setTitle:@"我的" forState:UIControlStateNormal];
    localMusicBtn.titleLabel.textColor = [UIColor whiteColor];
    localMusicBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    localMusicBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.view addSubview:localMusicBtn];
    
    UIButton *onLineMusicBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth/2+10, statusBarHeight, 60, 50)];
    [onLineMusicBtn setTitle:@"音乐库" forState:UIControlStateNormal];
    onLineMusicBtn.titleLabel.textColor = [UIColor whiteColor];
    onLineMusicBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    onLineMusicBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:onLineMusicBtn];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-80, statusBarHeight+50-1.5, 80, 1.5)];
    lineLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineLabel];
}

-(void)addScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-bottomHeight)];
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(screenWidth, 700+padding*7);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.panGestureRecognizer.delaysTouchesBegan = YES;
    NSInteger logoHeight = 280;
    UIImageView *logoImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, logoHeight)];
    logoImageView.image = [UIImage imageNamed:@"default_main_logo" ];
    logoImageView.contentMode = UIViewContentModeRedraw;
    [scrollView addSubview:logoImageView];
    
    
    [self addTopLeftAndBottomRightBtn:logoHeight withScrollView:scrollView options:YES];
    [self addTopRightAndBottomLeftBtn:logoHeight withScrollView:scrollView options:YES];
    [self addTopRightAndBottomLeftBtn:logoHeight withScrollView:scrollView options:NO];
    [self addTopLeftAndBottomRightBtn:logoHeight withScrollView:scrollView options:NO];
    
    [self addMyFavor:logoHeight+padding*3+80*2+10 withScrollView:scrollView];
    
    [self.view addSubview:scrollView];
}
-(void)addTopLeftAndBottomRightBtn:(NSInteger) logoHeight withScrollView:(UIScrollView *)scrollView options:(BOOL)isLeft{
    NSInteger baseHeight ;
    if (isLeft) {
        baseHeight= logoHeight+padding;
    }else{
        baseHeight = logoHeight+padding*2;
    }
    NSInteger width = (screenWidth-padding*3)/2;
    NSInteger height = 80;

    UIButton *btn;
    if (isLeft) {
        btn = [[UIButton alloc]initWithFrame:CGRectMake(padding, baseHeight, width, height)];
        btn.tag = 101;
    }else{
        btn = [[UIButton alloc]initWithFrame:CGRectMake(padding*2+width, baseHeight+height, width, height)];
        btn.tag = 104;
    }
//    btn.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#54A4E4"];
    btn.backgroundColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0];
   
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *decorate = [[UIImageView alloc]initWithFrame:CGRectMake(width-77, height-60, 77, 60)];
    decorate.userInteractionEnabled = NO;
    
    if (isLeft) {
        decorate.image = [UIImage imageNamed:@"my_music_local_music_decorate"];
    }else{
        decorate.image = [UIImage imageNamed:@"my_music_recent_play_decorate"];
    }
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake((width-100)/2,height/3, 100 ,10)];
    if (isLeft) {
        lable.text = @"本地音乐";
    }else{
        lable.text = @"最近播放";
    }
   
    lable.userInteractionEnabled = NO;
    lable.font = [UIFont systemFontOfSize:15];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake((width-100)/2, height/3*2, 100, 10)];
    label1.text = @"0首";
    label1.textColor = [UIColor_ColorChange colorWithHexString:@"#d9d9d9"];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:12];
    
    [btn addSubview:decorate];
    [btn addSubview:lable];
    [btn addSubview:label1];
    [scrollView addSubview:btn];
}

-(void)addTopRightAndBottomLeftBtn:(NSInteger) logoHeight withScrollView:(UIScrollView *)scrollView options:(BOOL)isRight{
    NSInteger baseHeight;
    NSInteger width = (screenWidth-padding*3)/2;
    NSInteger height = 80;

    if (isRight) {
        baseHeight = logoHeight+padding;
    }else{
        baseHeight = logoHeight+padding*2+height;
    }
    UIButton *btn;
    if (isRight) {
        btn = [[UIButton alloc]initWithFrame:CGRectMake(padding*2+width, baseHeight, width, height)];
        btn.tag = 102;
    }else{
        btn = [[UIButton alloc]initWithFrame:CGRectMake(padding, baseHeight, width, height)];
        btn.tag = 103;
    }
   
    btn.backgroundColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:0.67];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake((width-100)/2,height/3, 100 ,10)];
    if (isRight) {
        lable.text = @"歌曲下载";
    }else{
        lable.text= @"MV下载";
    }
   
    lable.userInteractionEnabled = NO;
    lable.font = [UIFont systemFontOfSize:15];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake((width-100)/2, height/3*2, 100, 10)];
    label1.text = @"没有下载任务";
    label1.textColor = [UIColor_ColorChange colorWithHexString:@"#d9d9d9"];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:12];
    
    
    [btn addSubview:lable];
    [btn addSubview:label1];
    [scrollView addSubview:btn];
}

-(void)addMyFavor:(NSInteger) baseHeight withScrollView:(UIScrollView *)scrollView{
#pragma mark 我的收藏Label
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(padding, baseHeight, 100, 10)];
    title.text = @"我的收藏";
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:15];
    [scrollView addSubview:title];
    
#pragma mark 我的最爱button
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(padding, baseHeight+10+padding, screenWidth-padding*2, 70)];
    btn.tag = 105;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    imageView1.backgroundColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0];
    [imageView1 setImage:[UIImage imageNamed:@"favor"]];
    imageView1.contentMode = UIViewContentModeCenter;
    [btn addSubview:imageView1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(padding+70,20, 100, 10)];
    label1.text = @"我的最爱";
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:13];
    [btn addSubview:label1];
    
    UILabel *label1_value = [[UILabel alloc]initWithFrame:CGRectMake(padding+70,10+20+20, 50, 10)];
    label1_value.text = @"0首";
    label1_value.textColor = [UIColor grayColor];
    label1_value.font = [UIFont systemFontOfSize:11];
    [btn addSubview:label1_value];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-7-padding*2, (70-17)/2, 7, 17)];
    imageView.image = [UIImage imageNamed:@"img_setting_right_arrow"];
    [btn addSubview:imageView];
    [scrollView addSubview:btn];
    
    
#pragma mark 收藏的歌单button
    NSInteger baseHeight2 = baseHeight+10+padding+70+10;
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(padding,baseHeight2 , screenWidth-padding*2, 70)];
    btn2.tag = 106;
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    imageView2.backgroundColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0];
    [imageView2 setImage:[UIImage imageNamed:@"img_favor_songlist"]];
    imageView2.contentMode = UIViewContentModeCenter;
    [btn2 addSubview:imageView2];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(padding+70, 20, 100, 10)];
    label2.text = @"收藏的歌单";
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:13];
    [btn2 addSubview:label2];
    
    UILabel *label2_value = [[UILabel alloc]initWithFrame:CGRectMake(padding+70, 20+10+20, 50, 10)];
    label2_value.text = @"0个";
    label2_value.textColor = [UIColor grayColor];
    label2_value.font = [UIFont systemFontOfSize:11];
    [btn2 addSubview:label2_value];
    
    UIImageView *imageView2_arrow = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-padding*2-7, (70-17)/2, 7, 17)];
    imageView2_arrow.image = [UIImage imageNamed:@"img_setting_right_arrow"];
    [btn2 addSubview:imageView2_arrow];
    
    [scrollView addSubview:btn2];
    
#pragma mark 我创建的歌单
    NSInteger baseHeight3 = baseHeight2 + 70 + padding*2;
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(padding, baseHeight3, 100, 10)];
    label3.text = @"我创建的歌单";
    label3.textColor = [UIColor blackColor];
    label3.font =[UIFont systemFontOfSize:15];
    [scrollView addSubview:label3];
    
    UILabel *label3_value  =[[UILabel alloc]initWithFrame:CGRectMake(padding+100, baseHeight3, 30, 10)];
    label3_value.text = @"0个";
    label3_value.textColor = [UIColor grayColor];
    label3_value.font = [UIFont systemFontOfSize:11];
    [scrollView addSubview:label3_value];
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(padding, baseHeight3+10+padding, screenWidth-padding*2, 70)];
    btn3.tag = 107;
    [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    imageView3.backgroundColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0];
    imageView3.image = [UIImage imageNamed:@"img_create_new_song_list"];
    imageView3.contentMode = UIViewContentModeCenter;
    [btn3 addSubview:imageView3];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(70+padding,30 , 100, 10)];
    label4.text = @"点击创建歌单";
    label4.textColor = [UIColor blackColor];
    label4.font = [UIFont systemFontOfSize:13];
    [btn3 addSubview:label4];
    UIImageView *imageView4_arrow = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-padding*2-7, (70-17)/2, 7, 17)];
    imageView4_arrow.image = [UIImage imageNamed:@"img_setting_right_arrow"];
    [btn3 addSubview:imageView4_arrow];
    [scrollView addSubview:btn3];
    
    NSLog(@"最终的高度是：%d",(280+padding*3+80*2+10+10+padding+70+10 + 70 + padding*2+10+padding+70+10));
//    UILabel *lable_test  =[[UILabel alloc]initWithFrame:CGRectMake(0, 770, screenWidth, 1)];
//    lable_test.backgroundColor = [UIColor redColor];
//    [scrollView addSubview:lable_test];
}

-(void)btnClick:(UIButton *)btn{
    NSInteger tag = btn.tag;
    switch (tag) {
        case 101:
             NSLog(@"本地音乐点击");
            break;
        case 102:
            NSLog(@"音乐下载点击");
            break;
        case 103:
            NSLog(@"MV下载点击");
            break;
        case 104:
            NSLog(@"最近播放点击");
            break;
        case 105:
            NSLog(@"我的最爱点击");
            break;
        case 106:
            NSLog(@"收藏的歌单点击");
            break;
        case 107:
            NSLog(@"点击新建歌单");
            break;
        case 108:
            NSLog(@"点击底部的widget");
            break;
        case 109:
            NSLog(@"点击了播放按钮");
            break;
        case 110:
            NSLog(@"点击了歌单按钮");
            break;
        default:
            break;
    }
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
