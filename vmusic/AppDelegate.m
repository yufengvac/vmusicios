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
#import "MyMusicQueueId.h"
#import "TingSongUtil.h"
#import "MusicQueueSheetView.h"
#import "UIColor+ColorChange.h"
#import "PlayMusicViewController.h"
#import "SCPresentTransition.h"
#import "UIImageView+WebCache.h"
#import "FileUtils.h"
#define screenWidth  [[UIScreen mainScreen]bounds].size.width
#define screenHeight  [[UIScreen mainScreen]bounds].size.height
#define bottomHeight 60
@interface AppDelegate ()
@property(nonnull,strong) STKAudioPlayer *audioPlayer;
@property(strong,nonatomic) NSMutableArray *musicQueueArray;
@property(assign,nonatomic) int currentIndex;
@property(strong,nonatomic) TingSong *currentTingSong;
@property(weak,nonatomic) NSTimer *progressTimer;
@property(strong,nonatomic) UIProgressView *progressView;
@property(assign,nonatomic) BOOL isLocalM;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initWindow];
    [self addSplashScreen];
    [self initAudio];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(showBottom) name:@"showBottom" object:nil];
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
    
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUi) userInfo:nil repeats:YES];
    [self.progressTimer setFireDate:[NSDate distantFuture]];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, baseHeight, screenWidth, bottomHeight)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = 108;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    self.progressView.trackTintColor = [UIColor_ColorChange colorWithHexString:@"#EBEDED"];
    self.progressView.progressTintColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0];
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 0.5f);
    self.progressView.transform = transform;
    self.progressView.progress = 0;
    self.progressView.tag = 1000;
    [btn addSubview:self.progressView];
    
    UIImageView *singerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(margin, margin, bottomHeight-margin*2, bottomHeight-margin*2)];
    singerImageView.layer.masksToBounds = YES;
    singerImageView.image = [UIImage imageNamed:@"default_bg"];
    singerImageView.layer.cornerRadius = (bottomHeight-margin*2)/2;
    singerImageView.tag = 301;
    singerImageView.contentMode = UIViewContentModeScaleAspectFill;
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
    
    
    UILabel *songNameLable = [[UILabel alloc]initWithFrame:CGRectMake(bottomHeight,(bottomHeight-20)/3, screenWidth-bottomHeight-width*2, 20)];
    songNameLable.font = [UIFont systemFontOfSize:15];
    songNameLable.textColor = [UIColor blackColor];
    songNameLable.tag = 201;
    songNameLable.text = @"";
    [btn addSubview:songNameLable];
    
    UILabel *singerNameLable = [[UILabel alloc]initWithFrame:CGRectMake(bottomHeight,(bottomHeight-20)/3+20, screenWidth-bottomHeight-width*2, 20)];
    singerNameLable.tag = 202;
    singerNameLable.font = [UIFont systemFontOfSize:13];
    singerNameLable.textColor = [UIColor grayColor];
    singerNameLable.text = @"";
    [btn addSubview:singerNameLable];
    
    [self.window addSubview:btn];
    
    [self initializeDefaultDataList];
    NSNumber *lastSongId = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    self.isLocalM = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLocal"];
    self.currentIndex = [TingSongUtil getIndexOfMusicQueue:self.musicQueueArray bySongId:lastSongId];
    if (self.currentIndex>=0) {
        self.currentTingSong = self.musicQueueArray[self.currentIndex];
        songNameLable.text = self.currentTingSong.name;
        singerNameLable.text = self.currentTingSong.singerName;
        [self loadSingerPic:self.currentTingSong.singerName];
        
    }
    
}

-(void)showBottom{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"showBottom============");
        UIButton *btn = [self.window viewWithTag:108];
        btn.hidden = NO;
        if ([btn isHidden]) {
            NSLog(@"是隐藏的");
        }else{
            NSLog(@"是显示的");
        }
        
    });
    
}
-(void)initAudio{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    self.audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
    self.audioPlayer.meteringEnabled = YES;
    self.audioPlayer.volume = 1;
    self.audioPlayer.delegate = self;
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

-(void)btnClick:(UIButton *)btn{
    NSInteger tag = btn.tag;
    switch (tag) {
        case 108:{
            btn.hidden = YES;
            PlayMusicViewController *playMusicVc = [[PlayMusicViewController alloc]init];
            playMusicVc.delegate = self;
            playMusicVc.audioPlayer = self.audioPlayer;
            self.otherSongPlayDelegate = playMusicVc;
//            [self.window.rootViewController presentViewController:playMusicVc animated: YES completion:nil];
            //            [self.audioPlayer seekToTime:self.audioPlayer.duration-10];
            [[self getPresentedViewController] presentViewController:playMusicVc animated: YES completion:nil];

        }
            break;
        case 109:
            if (!self.audioPlayer){
                return;
            }
            
            if (self.audioPlayer.state == STKAudioPlayerStatePaused){
                [self.audioPlayer resume];
                [btn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
            }else if(self.audioPlayer.state == STKAudioPlayerStatePlaying){
                [self.audioPlayer pause];
                [btn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
            }else{
                [self initPlay:self.currentTingSong.songId index:self.currentIndex isLocal:self.isLocalM];
            }
            break;
        case 110:
            NSLog(@"点击了歌单按钮");
            MusicQueueSheetView *musicQueueView = [[MusicQueueSheetView alloc]init];
            musicQueueView.delegate = self;
            musicQueueView.dataArray = self.musicQueueArray;
            musicQueueView.curIndex = self.currentIndex;
            musicQueueView.curSongId = ((TingSong *)[self.musicQueueArray objectAtIndex:self.currentIndex]).songId;
            if ([self.audioPlayer state]==STKAudioPlayerStatePlaying) {
                musicQueueView.curState = 1;
            }else{
                musicQueueView.curState = 0;
            }
            
            [musicQueueView showInView:self.window];
            break;
    }
}
- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = self.window.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

-(void)play{
    NSURL *url = [NSURL URLWithString:@"http://m6.file.xiami.com/849/849/4058/49645_16376576_h.mp3?auth_key=53cb00c028a829badd9cc10f06140967-1481338800-0-null"];
    
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
-(void)setTingSongQueue:(NSMutableArray *)tingSongArray{
    NSLog(@"TingSongArray.count=%ld",tingSongArray.count);
    if (self.musicQueueArray==nil) {
        self.musicQueueArray = [[NSMutableArray alloc]init];
         [self.musicQueueArray addObjectsFromArray:tingSongArray];
         NSLog(@"musicQueueArray.count=%ld",tingSongArray.count);
    }else{
        [self.musicQueueArray removeAllObjects];
        [self.musicQueueArray addObjectsFromArray:tingSongArray];
        NSLog(@"self.musicQueueArray.count=%ld",self.musicQueueArray.count);
    }
}


-(NSInteger)initPlay:(NSNumber *)songId index:(int)index isLocal:(BOOL) isLocalMusic{
    self.isLocalM = isLocalMusic;
    if (self.musicQueueArray.count==0) {
        NSLog(@"播放队列为空！");
        return 0;
    }
    if (index>=self.musicQueueArray.count||index<0) {
        NSLog(@"数组越界!");
        return 0;
    }
    if (!self.audioPlayer) {
        NSLog(@"audioPlayer未初始化");
        return 0;
    }
    NSInteger state = 0;
    if (self.audioPlayer.state ==STKAudioPlayerStateStopped) {
        self.currentIndex = index;
        [self playSong:index];
        state =  1;
    }else if (self.audioPlayer.state == STKAudioPlayerStatePaused){
        if ([songId integerValue]==[self.currentTingSong.songId integerValue]) {
            [self.audioPlayer resume];
        }else{
            self.currentIndex = index;
            [self playSong:index];
        }
        state =  1;
    }else if (self.audioPlayer.state == STKAudioPlayerStatePlaying){
        if ([songId integerValue]== [self.currentTingSong.songId integerValue]) {
            [self.audioPlayer pause];
             state =  0;
        }else{
            self.currentIndex = index;
            [self playSong:index];
            state =  1;
        }
    }

    
    //    for (int i=index+1; i<self.musicQueueArray.count; i++) {
    //        TingSong *queueTingSong = [self.musicQueueArray objectAtIndex:i];
    //        if (queueTingSong.auditionList.count>0) {
    //             TingAudition *tingAudion = [queueTingSong.auditionList lastObject];
    //            NSURL *ququeUrl = [NSURL URLWithString:tingAudion.url];
    //            [self.audioPlayer queueURL:ququeUrl withQueueItemId:[[MyMusicQueueId alloc]initWithUrl:ququeUrl andCount:0 andTingSong:queueTingSong]];
    //            NSLog(@"添加到第%d队列%@",i,tingAudion.url);
    //        }
    //
    //    }
    
    //    NSURL *queueUrl = [NSURL URLWithString:@"http://m6.file.xiami.com/260/1260/168592/2081179_1439370573.mp3?auth_key=69750fb56a655719cab80b2664bc3108-1481079600-0-null"] ;
    //    [self.audioPlayer queueURL:queueUrl withQueueItemId:[[MyMusicQueueId alloc]initWithUrl:queueUrl andCount:0]];
    
    
    
    UILabel *songNameLabel = [[self.window viewWithTag:108] viewWithTag:201];
    songNameLabel.text = self.currentTingSong.name;
    UILabel *singerLabel = [[self.window viewWithTag:108] viewWithTag:202];
    singerLabel.text = self.currentTingSong.singerName;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.musicQueueArray];
    
    [defaults setObject:data forKey:@"musicQueueArray"];
    [defaults setObject:self.currentTingSong.songId forKey:@"id"];
    [defaults setBool:isLocalMusic forKey:@"isLocal"];
    
    [defaults synchronize];
    
    //    for (int i=0; i<self.musicQueueArray.count; i++) {
    //        TingSong *ts = self.musicQueueArray[i];
    //        NSLog(@"%@",[ts description]);
    //    }
    
    //    NSArray *pendingQueue  = self.audioPlayer.pendingQueue;
    //    for (int i=0; i<pendingQueue.count; i++) {
    //        NSString *t = pendingQueue[i];
    //        NSLog(@"播放队列%d,名字是：%@",i,t);
    //    }
    //    NSLog(@"播放队列数量是：%ld",[self.audioPlayer pendingQueueCount]);
    return state;
}

-(TingSong *)getCurrentTingSong{
    return self.currentTingSong;
}
-(void)togglePlayPause{
    if (self.audioPlayer.state == STKAudioPlayerStatePaused){
        [self.audioPlayer resume];
    }else if(self.audioPlayer.state == STKAudioPlayerStatePlaying){
        [self.audioPlayer pause];
    }else{
        [self initPlay:self.currentTingSong.songId index:self.currentIndex isLocal:self.isLocalM];
    }
}
-(void)playNext{
    if (self.currentIndex+1<self.musicQueueArray.count) {
        TingSong *tingSong = self.musicQueueArray[self.currentIndex+1];
        [self initPlay:tingSong.songId index:(self.currentIndex+1) isLocal:self.isLocalM];
    }else{
        NSLog(@"已经最后一首啦！");
    }
}
-(void)playPre{
    if (self.currentIndex-1>=0) {
        TingSong *tingSong = self.musicQueueArray[self.currentIndex-1];
        [self initPlay:tingSong.songId index:(self.currentIndex-1) isLocal:self.isLocalM];
    }else{
        NSLog(@"已经是第一首啦！");
    }
   
}

-(void)playSong:(int)index{
    if (index>=self.musicQueueArray.count) {
        NSLog(@"index=%d,self.musicQueueArray.count = %ld,超过了最后一条",index,self.musicQueueArray.count);
        [self.audioPlayer stop];
        return;
    }
    
    self.currentTingSong = self.musicQueueArray[index];
    if (self.currentTingSong.auditionList.count>0) {
        TingAudition *tingAudition = [self.currentTingSong.auditionList lastObject];
        NSURL *playUrl;
        if (self.isLocalM) {
            playUrl = [NSURL fileURLWithPath:[FileUtils getSongPathByFileName:[NSString stringWithFormat:@"%@.mp3",self.currentTingSong.name]]];
        }else{
            playUrl = [NSURL URLWithString:tingAudition.url];
        }
        
        self.progressView.progress = 0;
        
        [self.audioPlayer playURL:playUrl withQueueItemID:[[MyMusicQueueId alloc]initWithUrl:playUrl andCount:0 andTingSong:self.currentTingSong]];
        
        [self loadSingerPic:self.currentTingSong.singerName];
        [self.otherSongPlayDelegate newSongWillPlay:nil andNewSong:self.currentTingSong];
    }else{
        [self audioPlayer:self.audioPlayer unexpectedError:STKAudioPlayerErrorDataSource];
    }
}

-(void)updateUi{
    double percent =  [self.audioPlayer progress]/[self.audioPlayer duration];
    if (!isnan(percent)) {
        self.progressView.progress = percent;
    }
}

//-(void)toogglePlay:(TingSong *)tingSong index:(int)index{
//    NSLog(@"要播放的 是：%@",tingSong.name);
//    if (tingSong.auditionList.count>0) {
//        TingAudition *tingAudion = [tingSong.auditionList lastObject];
//        NSURL *playUrl = [NSURL URLWithString:tingAudion.url];
//        STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:playUrl];
//        
//        [self.audioPlayer setDataSource:dataSource withQueueItemId:[[MyMusicQueueId alloc]initWithUrl:playUrl andCount:0 andTingSong:tingSong]];
//    }
//
////    for (int i=index+1; i<self.musicQueueArray.count; i++) {
////        TingSong *queueTingSong = [self.musicQueueArray objectAtIndex:i];
////        if (queueTingSong.auditionList.count>0) {
////             TingAudition *tingAudion = [queueTingSong.auditionList lastObject];
////            NSURL *ququeUrl = [NSURL URLWithString:tingAudion.url];
////            [self.audioPlayer queueURL:ququeUrl withQueueItemId:[[MyMusicQueueId alloc]initWithUrl:ququeUrl andCount:0 andTingSong:queueTingSong]];
////            NSLog(@"添加到第%d队列%@",i,tingAudion.url);
////        }
////    }
//    
////    NSURL *queueUrl = [NSURL URLWithString:@"http://m6.file.xiami.com/260/1260/168592/2081179_1439370573.mp3?auth_key=69750fb56a655719cab80b2664bc3108-1481079600-0-null"] ;
////    [self.audioPlayer queueURL:queueUrl withQueueItemId:[[MyMusicQueueId alloc]initWithUrl:queueUrl andCount:0]];
//
//    
//    
//    UILabel *songNameLabel = [[self.window viewWithTag:108] viewWithTag:201];
//    songNameLabel.text = tingSong.name;
//    UILabel *singerLabel = [[self.window viewWithTag:108] viewWithTag:202];
//    singerLabel.text = tingSong.singerName;
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.musicQueueArray];
//    
//    [defaults setObject:data forKey:@"musicQueueArray"];
//    [defaults setObject:tingSong.songId forKey:@"id"];
//    [defaults synchronize];
//    
////    for (int i=0; i<self.musicQueueArray.count; i++) {
////        TingSong *ts = self.musicQueueArray[i];
////        NSLog(@"%@",[ts description]);
////    }
//    
////    NSArray *pendingQueue  = self.audioPlayer.pendingQueue;
////    for (int i=0; i<pendingQueue.count; i++) {
////        NSString *t = pendingQueue[i];
////        NSLog(@"播放队列%d,名字是：%@",i,t);
////    }
////    NSLog(@"播放队列数量是：%ld",[self.audioPlayer pendingQueueCount]);
//}

-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didStartPlayingQueueItemId:(NSObject *)queueItemId{
    NSLog(@"didStartPlayingQueueItemId");
    TingSong *tingSong = ((MyMusicQueueId *)queueItemId).tingSong;
    UILabel *songNameLabel = [[self.window viewWithTag:108] viewWithTag:201];
    songNameLabel.text = tingSong.name;
    UILabel *singerLabel = [[self.window viewWithTag:108] viewWithTag:202];
    singerLabel.text = tingSong.singerName;
    [self loadSingerPic:tingSong.singerName];
    
    [self.otherSongPlayDelegate newSongDidPlay:tingSong];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:tingSong.songId forKey:@"id"];
    [defaults synchronize];
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId{
    NSLog(@"didFinishBufferingSourceWithQueueItemId");
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
    NSLog(@"stateChanged = %ld，previousState = %ld",state,previousState);
    UIButton *btn = [self.window viewWithTag:109];
    if (state == STKAudioPlayerStatePaused){
        [btn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
        if (self.progressTimer!=nil) {
            [self.progressTimer setFireDate:[NSDate distantFuture]];
        }
    }else{
        [btn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
        if (self.progressTimer!=nil) {
            [self.progressTimer setFireDate:[NSDate distantPast]];
        }
    }
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode{
    NSLog(@"unexpectedError=%ld",errorCode);
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer logInfo:(NSString *)line{
    NSLog(@"logInfo--%@",line);
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didCancelQueuedItems:(NSArray *)queuedItems{
    NSLog(@"didCancelQueueItems");
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration{
    NSLog(@"STKAudioPlayerStopReason=%ld",stopReason);
    if (stopReason==1) {
        TingSong *tingSong = ((MyMusicQueueId *)queueItemId).tingSong;
        NSLog(@"didFinishPlayingQueueItemId=%@,progress=%f",tingSong.name,progress);
        NSInteger mode = [[NSUserDefaults standardUserDefaults]integerForKey:@"mode"];
        if (mode==0) {
            if (self.currentIndex+1>=self.musicQueueArray.count) {
                self.currentIndex=0;
            }else{
                self.currentIndex = self.currentIndex+1;
            }
        }else if (mode==1){
            if (self.currentIndex+1>=self.musicQueueArray.count) {
                [self.audioPlayer stop];
            }else{
                self.currentIndex = self.currentIndex+1;
            }
        }else if (mode==2){
            self.currentIndex = self.currentIndex;
        }else if (mode==3){
            self.currentIndex = arc4random() % self.musicQueueArray.count;
        }
        
        [self playSong:self.currentIndex];
    }
}

-(void)loadSingerPic:(NSString *)singerName{
    UIImageView *singerImageView = [[self.window viewWithTag:108] viewWithTag:301];
    singerImageView.image = [UIImage imageNamed:@"default_bg"];
    dispatch_queue_t serialQueue = dispatch_queue_create("loadSingerPic", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        NSString *url = [NSString stringWithFormat:@"http://search.dongting.com/artist/search?q=%@&size=1",singerName];
        NSLog(@"loadSingerPic->%@",singerName);
        NSString *urlEncode = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLCache *urlCache = [[NSURLCache alloc]initWithMemoryCapacity:4*1024*1024 diskCapacity:50*1024*1024 diskPath:nil];
        [NSURLCache setSharedURLCache:urlCache];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlEncode] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
            if ([data isKindOfClass:[NSNull class]]||data ==nil) {
                return;
            }
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSMutableArray *array = [json mutableArrayValueForKey:@"data"];
            if (array.count>0) {
                NSDictionary *json1 = [array objectAtIndex:0];
                NSString *picUrl = [NSString stringWithFormat:@"%@",[json1 objectForKey:@"pic_url"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    [singerImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"default_bg"] options:SDWebImageContinueInBackground];
                });
            }
        }];
        [task resume];
    });
}

-(void)initializeDefaultDataList{
    NSUserDefaults   *defaults = [NSUserDefaults standardUserDefaults];
    NSData   *savedEncodedData = [defaults objectForKey:@"musicQueueArray"];
    if(savedEncodedData   == nil){
        NSMutableArray   *sightingList = [[NSMutableArray alloc] init];
        self.musicQueueArray   = sightingList;
    }else{
        self.musicQueueArray   = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedData];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (self.progressTimer!=nil) {
        [self.progressTimer setFireDate:[NSDate distantFuture]];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (self.progressTimer!=nil) {
        [self.progressTimer setFireDate:[NSDate distantPast]];
    }
    [self showBottom];
    NSLog(@"applicationDidBecomeActive");
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
