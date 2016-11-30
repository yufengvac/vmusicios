//
//  AppDelegate.m
//  vmusic
//
//  Created by feng yu on 16/11/29.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "AppDelegate.h"
#import "STKAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#define screenWidth  [[UIScreen mainScreen]bounds].size.width
#define screenHeight  [[UIScreen mainScreen]bounds].size.height
#define bottomHeight 60
@interface AppDelegate ()
@property(nonnull,strong) STKAudioPlayer *audioPlayer;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initWindow];
    [self addSplashScreen];
    [self initAudio];
    
    return YES;
}
-(void)initWindow{
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    MainViewController *mainController = [[MainViewController alloc]init];
    mainController.delegate = self;
    self.window.rootViewController = mainController;
}

-(void)addSplashScreen{
    self.window.rootViewController.view.alpha = 0;
    UIImageView *splashImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth,screenHeight )];
    splashImageView.image = [UIImage imageNamed:@"splash_screen"];
    [self.window addSubview:splashImageView];
    [UIView animateWithDuration:0.7 animations:^{
        self.window.rootViewController.view.alpha = 1.0;
    }completion:^(BOOL finished){
        [splashImageView removeFromSuperview];
        [self addBottomView];
    }];
}
-(void)addBottomView{
    NSInteger baseHeight = screenHeight - bottomHeight;
    NSInteger margin = 10;
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0,baseHeight, screenWidth, 0.3)];
    line.backgroundColor = [UIColor blackColor];
    [self.window addSubview:line];
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
    [self.window addSubview:btn];
}
-(void)initAudio{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    self.audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
    self.audioPlayer.meteringEnabled = YES;
    self.audioPlayer.volume = 1;
    
}

-(void)btnClick:(UIButton *)btn{
    NSInteger tag = btn.tag;
    switch (tag) {
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

-(void)play{
    NSURL *url = [NSURL URLWithString:@"http://m6.file.xiami.com/260/1260/436317/1770153970_1439388803.mp3?auth_key=0cbfb0ae5060577996899de89a49afe8-1480734000-0-null"];
    
    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
    
    [self.audioPlayer playDataSource:dataSource];
  
    [self.audioPlayer queueURL:[NSURL URLWithString:@"http://m6.file.xiami.com/260/1260/350824/1769164002_1441381832.mp3?auth_key=2ae4dfce15f3b00d5cf64b4986edbef7-1481079600-0-null"]];
    [self.audioPlayer queueURL:[NSURL URLWithString:@"http://m5.file.xiami.com/169/7169/415752/1769918293_2309762_l.mp3?auth_key=78972371c5f4efb799a18bc6137fcf28-1481079600-0-null"]];
    [self.audioPlayer queueURL:[NSURL URLWithString:@"http://m6.file.xiami.com/812/634530812/2100361431/1776230341_60378614_h.mp3?auth_key=31fe0f10d99aba78d819469cfb075171-1481079600-0-null"]];
    [self.audioPlayer queueURL:[NSURL URLWithString:@"http://m6.file.xiami.com/197/1964894197/2100314404/1775919020_60013952_h.mp3?auth_key=fe5e9528d40f0449ea264c79488a5d94-1481079600-0-null"]];
    [self.audioPlayer queueURL:[NSURL URLWithString:@"http://m5.file.xiami.com/1/169/7169/189915/2307728_119184_l.mp3?auth_key=aebef621c7af7b93b4a9457fd44541fd-1481079600-0-null"]];
    [self.audioPlayer queueURL:[NSURL URLWithString:@"http://m6.file.xiami.com/260/1260/33046/394604_3959845_h.mp3?auth_key=7973b0de56a9d6ccecc779a81fbe993e-1481079600-0-null"]];
    [self.audioPlayer queueURL:[NSURL URLWithString:@"http://m6.file.xiami.com/260/1260/436317/1770153970_1439388803.mp3?auth_key=0cbfb0ae5060577996899de89a49afe8-1480734000-0-null"]];
    [self.audioPlayer queueURL:[NSURL URLWithString:@"http://m6.file.xiami.com/260/1260/168592/2081179_1439370573.mp3?auth_key=69750fb56a655719cab80b2664bc3108-1481079600-0-null"]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end