//
//  MainViewController.m
//  vmusic
//
//  Created by feng yu on 16/11/29.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "MainViewController.h"
#import "UIColor+ColorChange.h"
#import "SearchViewController.h"

#import "SCPresentTransition.h"

#define screenWidth  [[UIScreen mainScreen]bounds].size.width
#define screenHeight  ([[UIScreen mainScreen]bounds].size.height)
#define statusBarHeight 15
#define padding 10
#define bottomHeight 60
#define topContentHeight 50
@interface MainViewController ()
@property UIImageView *bgImageView;
@property UILabel *indicator;
@property UIButton *localMusicBtn;
@property UIButton *onLineMusicBtn;
@property UIScrollView *horizonScrollView;
@end

@implementation MainViewController

-(instancetype)initWithFrame:(CGRect)rect{
    if (self == [super init]) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    [self addHorizontalScrollView];
    [self addScrollView];
    [self addTopContent];
    
}

-(void)addHorizontalScrollView{
    self.horizonScrollView= [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-bottomHeight)];
    self.horizonScrollView.scrollEnabled = YES;
    self.horizonScrollView.contentSize  = CGSizeMake(screenWidth*2, screenHeight-bottomHeight);
    self.horizonScrollView.pagingEnabled = YES;
    self.horizonScrollView.bounces = NO;
    self.horizonScrollView.tag = 301;
    self.horizonScrollView.delegate = self;
    self.horizonScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.horizonScrollView];
}


-(void)addScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-bottomHeight)];
    scrollView.scrollEnabled = YES;
    scrollView .tag = 302;
    scrollView.delegate = self;
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
    
    [[self.view viewWithTag:301] addSubview:scrollView];
}

-(void)addTopContent{
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, statusBarHeight+topContentHeight)];
    bgImageView.tag = 201;
    [bgImageView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]];
    [self.view addSubview:bgImageView];
    
    UIButton *menuBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, statusBarHeight, topContentHeight , topContentHeight)];
    [menuBtn setImage:[UIImage imageNamed:@"main_head_left_menu"] forState:UIControlStateNormal];
    menuBtn.tag = 113;
    [menuBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:menuBtn];
    
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth-50, statusBarHeight, topContentHeight, topContentHeight)];
    searchBtn.tag = 114;
    [searchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [searchBtn setImage:[UIImage imageNamed:@"main_head_right_search"] forState:UIControlStateNormal];
    [self.view addSubview:searchBtn];
    
    UIButton *localMusicBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth/2-70, statusBarHeight, 60, topContentHeight)];
    [localMusicBtn setTitle:@"我的" forState:UIControlStateNormal];
    localMusicBtn.tag = 111;
    [localMusicBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    localMusicBtn.titleLabel.textColor = [UIColor whiteColor];
    localMusicBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    localMusicBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.view addSubview:localMusicBtn];
    
    UIButton *onLineMusicBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth/2+10, statusBarHeight, 60, topContentHeight)];
    [onLineMusicBtn setTitle:@"音乐库" forState:UIControlStateNormal];
    onLineMusicBtn.tag = 112;
    [onLineMusicBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    onLineMusicBtn.titleLabel.textColor = [UIColor whiteColor];
    onLineMusicBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    onLineMusicBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:onLineMusicBtn];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-80, statusBarHeight+50-1.5, 80, 1.5)];
    lineLabel.tag = 401;
    lineLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineLabel];
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
        case 111:
            [self.horizonScrollView setContentOffset:CGPointMake(0,0) animated:YES];
            break;
        case 112:
            [self.horizonScrollView setContentOffset:CGPointMake(screenWidth,0) animated:YES];
            break;
        case 113:
            break;
        case 114:
            NSLog(@"点击了搜索按钮");
            SearchViewController *searchView = [[SearchViewController alloc]init];
            searchView.delegate = self.delegate;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:searchView];
            nav.navigationBarHidden = YES;
            [SCPresentTransition presentViewController:nav animated:YES completion:nil];
            break;
    }
}




-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    CGFloat offestY = point.y;
    CGFloat offestX = point.x;
    if (self.bgImageView==nil) {
        self.bgImageView =  [self.view viewWithTag:201];
    }
    if (self.indicator == nil) {
        self.indicator = [self.view viewWithTag:401];
    }
    if (self.localMusicBtn==nil) {
        self.localMusicBtn = [self.view viewWithTag:111];
    }
    if (self.onLineMusicBtn==nil) {
        self.onLineMusicBtn = [self.view viewWithTag:112];
    }
    if (scrollView.tag==302) {//上下滑动
        if (offestY>10&&offestY<=163) {
            CGFloat scale = offestY/163;
            self.currentRed = (0.33-0.0627-0)*scale;
            self.currentGreen = (0.64-0.0627-0)*scale;
            self.currentBlue = (0.89-0.0627-0)*scale;
            self.currentAlpha = ((1.0-0.1)*scale+0.1);
        }else if (offestY<=10){
            self.currentRed = 0;self.currentGreen = 0;self.currentBlue=0;self.currentAlpha = 0.1;
        }else if (offestY>163){
            self.currentRed =(0.33-0.0627);
            self.currentGreen = (0.64-0.0627);
            self.currentBlue = (0.89-0.0627);
            self.currentAlpha = 1.0;
        }
        self.bgImageView.backgroundColor = [UIColor colorWithRed:self.currentRed green:self.currentGreen blue:self.currentBlue alpha:self.currentAlpha];
    }else if(scrollView.tag==301){//左右滑动
        if (offestX>0&&offestX<=screenWidth) {
            CGFloat scale = offestX*1.0/screenWidth;
             self.bgImageView.backgroundColor = [UIColor colorWithRed:((0.33-0.0627-self.currentRed)*scale+self.currentRed) green:self.currentGreen+(0.64-0.0627-self.currentGreen)*scale blue:self.currentBlue+(0.89-0.0627-self.currentBlue)*scale alpha:((1.0-self.currentAlpha)*scale+self.currentAlpha)];

            CGRect cgRect = CGRectMake(screenWidth/2-80+80*scale, statusBarHeight+50-1.5, 80, 1.5);
            self.indicator.frame = cgRect;
            if (scale>=0.99) {
                self.onLineMusicBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
                self.localMusicBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            }else if(scale<=0.01){
                self.localMusicBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
                self.onLineMusicBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            }
        }
    }
    
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
