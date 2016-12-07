//
//  PlayMusicViewController.m
//  vmusic
//
//  Created by feng yu on 16/12/7.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "PlayMusicViewController.h"
#import "UIColor+ColorChange.h"
#define screenWidth  [[UIScreen mainScreen]bounds].size.width
#define screenHeight  [[UIScreen mainScreen]bounds].size.height
#define statusBarHeight 15
#define margin 10
#define bottomHeight 145

@interface PlayMusicViewController ()

@end

@implementation PlayMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [imageView setImage:[UIImage imageNamed:@"default_music"]];
    [self.view addSubview:imageView];
    [self addTopContent];
    
    [self addBottomContent];
}
-(void) addTopContent{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, statusBarHeight, 50, 50)];
    [backBtn setImage:[UIImage imageNamed:@"icon_down_arrow"] forState:UIControlStateNormal];
    backBtn.tag = 101;
    [backBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backBtn];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(50, statusBarHeight, screenWidth-50*2, 50)];
    title.textColor = [UIColor whiteColor];
    title.font  = [UIFont systemFontOfSize:17];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"死不了";
    [self.view addSubview:title];
    
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth-50, statusBarHeight, 50, 50)];
    [moreBtn setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
    [self.view addSubview:moreBtn];
}

-(void)addBottomContent{
    
    NSInteger baseHeight = screenHeight - bottomHeight;
    
    UILabel *startLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, baseHeight, 45, 15)];
    startLabel.text = @"--:--";
    startLabel.textColor = [UIColor whiteColor];
    startLabel.font = [UIFont systemFontOfSize:13];
    startLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:startLabel];
    
    UIProgressView *progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(margin+45,baseHeight+7, screenWidth-2*(margin+45), 1)];
    progressView.trackTintColor = [UIColor_ColorChange colorWithHexString:@"#EBEDED"];
    progressView.progressTintColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0];
    progressView.progressViewStyle = UIProgressViewStyleBar;
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 0.5f);
    progressView.transform = transform;
    progressView.progress = 0;
    progressView.tag = 1000;
    [self.view addSubview:progressView];
    
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth-(margin+45), baseHeight, 45, 15)];
    totalLabel.text = @"--:--";
    totalLabel.textColor = [UIColor whiteColor];
    totalLabel.textAlignment = NSTextAlignmentCenter;
    totalLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:totalLabel];
    
    UIButton *playBtn = [[UIButton alloc]initWithFrame:CGRectMake((screenWidth-64)/2, baseHeight+15+margin, 64, 64)];
    [playBtn setImage:[UIImage imageNamed:@"icon_play_play"] forState:UIControlStateNormal];
    [self.view addSubview:playBtn];
    
    UIButton *preBtn = [[UIButton alloc]initWithFrame:CGRectMake((screenWidth-64)/2-50-margin*3, baseHeight+15+margin,64, 64)];
    [preBtn setImage:[UIImage imageNamed:@"icon_play_pre"] forState:UIControlStateNormal];
    [self.view addSubview:preBtn];
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake((screenWidth-64)/2+50+margin*3, baseHeight+15+margin,64, 64 )];
    [nextBtn setImage:[UIImage imageNamed:@"icon_play_next"] forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    
    
    
    NSInteger oneSize = screenWidth/5;
    UIButton *favor = [[UIButton alloc]initWithFrame:CGRectMake(0, baseHeight+margin+64, oneSize, oneSize)];
    [favor setImage:[UIImage imageNamed:@"icon_favor_music_no"] forState:UIControlStateNormal];
    [self.view addSubview:favor];
    
    UIButton *mode = [[UIButton alloc]initWithFrame:CGRectMake(oneSize, baseHeight+margin+64, oneSize, oneSize)];
    [mode setImage:[UIImage imageNamed:@"icon_mode_order_music"] forState:UIControlStateNormal];
    [self.view addSubview:mode];
    
    
    UIButton *download = [[UIButton alloc]initWithFrame:CGRectMake(oneSize*2, baseHeight+margin+64, oneSize, oneSize)];
    [download setImage:[UIImage imageNamed:@"icon_download_music"] forState:UIControlStateNormal];
    [self.view addSubview:download];
    
    UIButton *share = [[UIButton alloc]initWithFrame:CGRectMake(oneSize*3, baseHeight+margin+64, oneSize, oneSize)];
    [share setImage:[UIImage imageNamed:@"icon_share_music"] forState:UIControlStateNormal];
    [self.view addSubview:share];
    
    UIButton *songlist = [[UIButton alloc]initWithFrame:CGRectMake(oneSize*4, baseHeight+margin+64, oneSize, oneSize)];
    [songlist setImage:[UIImage imageNamed:@"icon_songlist_music"] forState:UIControlStateNormal];
    [self.view addSubview:songlist];
}


-(void)btnClick:(UIButton *)btn{
    NSInteger tag = btn.tag;
    switch (tag) {
        case 101:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            break;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [self performSelector:@selector(notifi) withObject:nil afterDelay:0.25f];
}
-(void)notifi{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showBottom" object:self];
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
