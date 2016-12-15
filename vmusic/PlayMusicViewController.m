//
//  PlayMusicViewController.m
//  vmusic
//
//  Created by feng yu on 16/12/7.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "PlayMusicViewController.h"
#import "UIColor+ColorChange.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "FileUtils.h"
#import "AlphaUtil.h"
#import "DBHelper.h"
#define screenWidth  [[UIScreen mainScreen]bounds].size.width
#define screenHeight  [[UIScreen mainScreen]bounds].size.height
#define statusBarHeight 15
#define margin 10
#define bottomHeight 145

@interface PlayMusicViewController ()
@property(strong,nonatomic) TingSong *tingSong;
@property(weak,nonatomic) NSTimer *progressTimer;
@property(weak,nonatomic) NSTimer *bgTimer;
@property(strong,nonatomic) UISlider *slider;
@property(strong,nonatomic) UILabel *curentTimerLabel;
@property(readwrite,nonatomic) NSInteger bgIndex;
@property(strong,nonatomic)UIImageView *imageView;
@property(strong,nonatomic)UIImageView *imageView1;
@property(readwrite,nonatomic)NSInteger downloadCount;
@end

@implementation PlayMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tingSong = [self.delegate getCurrentTingSong];
   
    
    self.imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.imageView.tag =1;
    self.imageView.alpha = 0;
    [self.imageView setImage:[UIImage imageNamed:@"default_music"]];
    
    self.imageView1 = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.imageView1.tag =2;
    [self.imageView1 setImage:[UIImage imageNamed:@"default_music"]];
    
    UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    coverImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    if ([FileUtils isExitPath:self.tingSong.singerName]) {
        NSArray *picArray = [FileUtils getPicsBySingerName:self.tingSong.singerName];
        if (picArray!=nil&&picArray.count>0) {
            NSString *path = [[FileUtils getRootSingerPathWithSingerName:self.tingSong.singerName] stringByAppendingPathComponent:picArray[self.bgIndex]];
            self.imageView1.image = [UIImage imageWithContentsOfFile:path];
        }
    }
    
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.imageView1];
    [self.view addSubview:coverImageView];
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
    title.text = self.tingSong.name;
    title.tag = 201;
    [self.view addSubview:title];
    
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth-50, statusBarHeight, 50, 50)];
    [moreBtn setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
    [self.view addSubview:moreBtn];
}

-(void)addBottomContent{
    
    NSInteger baseHeight = screenHeight - bottomHeight;
    
    self.curentTimerLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, baseHeight, 50, 15)];
    self.curentTimerLabel.text = [self formatTimeFromSeconds:[self.audioPlayer progress]];
    self.curentTimerLabel.textColor = [UIColor whiteColor];
    self.curentTimerLabel.font = [UIFont systemFontOfSize:13];
    self.curentTimerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.curentTimerLabel];
    
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(margin+50,baseHeight+7, screenWidth-2*(margin+50), 1)];
    self.slider.minimumTrackTintColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0];
    self.slider.maximumTrackTintColor = [UIColor whiteColor];
    [self.slider setThumbImage:[UIImage imageNamed:@"icon_seekbar_point"] forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.slider];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    tapGesture.delegate = self;
    [_slider addGestureRecognizer:tapGesture];
    [self updateUi];
    
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth-(margin+50), baseHeight, 50, 15)];
    totalLabel.text = [self formatTimeFromSeconds:[self.audioPlayer duration]];
    totalLabel.textColor = [UIColor whiteColor];
    totalLabel.textAlignment = NSTextAlignmentCenter;
    totalLabel.font = [UIFont systemFontOfSize:13];
    totalLabel.tag = 202;
    [self.view addSubview:totalLabel];
    
    UIButton *playBtn = [[UIButton alloc]initWithFrame:CGRectMake((screenWidth-64)/2, baseHeight+15+margin, 64, 64)];
    playBtn.tag = 102;
    [playBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    if ([self.audioPlayer state]==STKAudioPlayerStatePlaying) {
        [playBtn setImage:[UIImage imageNamed:@"icon_play_pause"] forState:UIControlStateNormal];
    }else{
        [playBtn setImage:[UIImage imageNamed:@"icon_play_play"] forState:UIControlStateNormal];
    }
    
    [self.view addSubview:playBtn];
    
    UIButton *preBtn = [[UIButton alloc]initWithFrame:CGRectMake((screenWidth-64)/2-50-margin*3, baseHeight+15+margin,64, 64)];
    preBtn.tag = 103;
    [preBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [preBtn setImage:[UIImage imageNamed:@"icon_play_pre"] forState:UIControlStateNormal];
    [self.view addSubview:preBtn];
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake((screenWidth-64)/2+50+margin*3, baseHeight+15+margin,64, 64 )];
    nextBtn.tag = 104;
    [nextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [nextBtn setImage:[UIImage imageNamed:@"icon_play_next"] forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    
    
    
    NSInteger oneSize = screenWidth/5;
    UIButton *favor = [[UIButton alloc]initWithFrame:CGRectMake(0, baseHeight+margin+64, oneSize, oneSize)];
    favor.tag = 105;
    [favor addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [favor setImage:[UIImage imageNamed:@"icon_favor_music_no"] forState:UIControlStateNormal];
    [self.view addSubview:favor];
    
    UIButton *mode = [[UIButton alloc]initWithFrame:CGRectMake(oneSize, baseHeight+margin+64, oneSize, oneSize)];
    mode.tag = 106;
    [mode addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [mode setImage:[UIImage imageNamed:@"icon_mode_order_music"] forState:UIControlStateNormal];
    [self.view addSubview:mode];
    
    
    UIButton *download = [[UIButton alloc]initWithFrame:CGRectMake(oneSize*2, baseHeight+margin+64, oneSize, oneSize)];
    download.tag = 107;
    [download addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [download setImage:[UIImage imageNamed:@"icon_download_music"] forState:UIControlStateNormal];
    [self.view addSubview:download];
    
    UIButton *share = [[UIButton alloc]initWithFrame:CGRectMake(oneSize*3, baseHeight+margin+64, oneSize, oneSize)];
    share.tag = 108;
    [share addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [share setImage:[UIImage imageNamed:@"icon_share_music"] forState:UIControlStateNormal];
    [self.view addSubview:share];
    
    UIButton *songlist = [[UIButton alloc]initWithFrame:CGRectMake(oneSize*4, baseHeight+margin+64, oneSize, oneSize)];
    songlist.tag = 109;
    [songlist addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [songlist setImage:[UIImage imageNamed:@"icon_songlist_music"] forState:UIControlStateNormal];
    [self.view addSubview:songlist];
}


-(void)btnClick:(UIButton *)btn{
    NSInteger tag = btn.tag;
    switch (tag) {
        case 101:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 102:
            [self.delegate togglePlayPause];
            break;
        case 103:
            [self.delegate playPre];
            break;
        case 104:
            [self.delegate playNext];
            break;
        case 105:
            break;
        case 106:
            break;
        case 107:
            [self downloadSong:self.tingSong];
            break;
        case 108:
            break;
        case 109:
            break;
        default:
            break;
    }
    
    UIButton *playBtn = [self.view viewWithTag:102];
    if ([self.audioPlayer state]==STKAudioPlayerStatePlaying||[self.audioPlayer state]==STKAudioPlayerStateBuffering) {
        [playBtn setImage:[UIImage imageNamed:@"icon_play_pause"] forState:UIControlStateNormal];
    }else{
        [playBtn setImage:[UIImage imageNamed:@"icon_play_play"] forState:UIControlStateNormal];
    }
}
-(void)sliderAction:(UISlider *)slider{
    CGFloat value =  slider.value;
    [self.audioPlayer seekToTime:[self.audioPlayer duration]*value];
}
- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:_slider];
    CGFloat value = (_slider.maximumValue - _slider.minimumValue) * (touchPoint.x / _slider.frame.size.width );
    [_slider setValue:value animated:YES];
    [self.audioPlayer seekToTime:[self.audioPlayer duration]*value];
    NSLog(@"actionTap");
}
- (IBAction)sliderTouchDown:(UISlider *)sender {
    NSLog(@"sliderTouchDown");
//    _tapGesture.enabled = NO;
}
- (IBAction)sliderTouchUp:(UISlider *)sender {
    if (sender) {
        NSLog(@"sliderTouchUp");
    } else {
        NSLog(@"sliderTouchUp from actionTap");
    }
//    _tapGesture.enabled = YES;
}

-(void)updateUi{
    double percent =  [self.audioPlayer progress]/[self.audioPlayer duration];
    if (!isnan(percent)) {
        self.slider.value = percent;
        self.curentTimerLabel.text = [self formatTimeFromSeconds:[self.audioPlayer progress]];
    }
}
-(void)newSongWillPlay:(TingSong *)oldTingSong andNewSong:(TingSong *)newSong{
    self.slider.value = 0;
    self.curentTimerLabel.text = @"00:00";
    
    
    UILabel *titleLabel = [self.view viewWithTag:201];
    titleLabel.text = newSong.name;
    NSLog(@"name是%@",newSong.name);
    
    
    if (newSong.auditionList.count>0) {
        TingAudition *audition = [newSong.auditionList lastObject];
        UILabel *totalTimeLabel = [self.view viewWithTag:202];
        totalTimeLabel.text =[self formatTimeFromSeconds:([audition.duration intValue]/1000.0)];
         NSLog(@"总时长是：%@，显示的时间是：%@",[self formatTimeFromSeconds:[self.audioPlayer duration]],totalTimeLabel.text);
    }
    [self.bgTimer invalidate];
    self.bgTimer = nil;
    
    self.tingSong = newSong;
    [self viewDidAppear:YES];
}
-(void)newSongDidPlay:(TingSong *)newSong{
//    UILabel *totalTimeLabel = [self.view viewWithTag:202];
//    totalTimeLabel.text =[self formatTimeFromSeconds:[self.audioPlayer duration]];
   
}

-(NSString*) formatTimeFromSeconds:(int)totalSeconds{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
//    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

-(void)viewWillDisappear:(BOOL)animated{
//    [self performSelector:@selector(notifi) withObject:nil afterDelay:0.25f];
    [self notifi];
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.bgTimer invalidate];
    self.bgTimer = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUi) userInfo:nil repeats:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    self.imageView.alpha = 0;
    [self.imageView setImage:[UIImage imageNamed:@"default_music"]];
    [self.imageView1 setImage:[UIImage imageNamed:@"default_music"]];
    if (![FileUtils isExitPath:self.tingSong.singerName]) {
        [self loadSingerPicJson:self.tingSong.singerName];
        
    }else{
        NSArray *picArray = [FileUtils getPicsBySingerName:self.tingSong.singerName];
        if (picArray.count==0) {
            return;
        }
        self.bgIndex = 0;
        NSString *path = [[FileUtils getRootSingerPathWithSingerName:self.tingSong.singerName] stringByAppendingPathComponent:picArray[0]];
        self.imageView.image =[UIImage imageWithContentsOfFile:path];
        self.imageView1.image =[UIImage imageWithContentsOfFile:path];
        
        if (picArray.count>1) {
            self.bgIndex = 1;
            self.bgTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(changeSingerPic:) userInfo:picArray repeats:YES];
        }
    
    }
}

-(void)notifi{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showBottom" object:self];
}
-(void)changeSingerPic:(NSTimer *)timer{
    NSArray *array = timer.userInfo;
    NSString *path = [[FileUtils getRootSingerPathWithSingerName:self.tingSong.singerName] stringByAppendingPathComponent:array[self.bgIndex%array.count]];

    NSLog(@"imageView的透明是%.2f,imageView1的透明度是%.2f",[self.imageView alpha],[self.imageView1 alpha]);
    if (self.imageView1.alpha<=0.05) {
        self.imageView1.image = [UIImage imageWithContentsOfFile:path];
        
        NSLog(@"imageView1要显示，imageView要隐藏");
        
        dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            for (int i =1; i<=50; i++) {
                __block CGFloat percent = i*i/(50.0*50.0);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.imageView1 setAlpha:percent];
                    [self.imageView setAlpha:(1-percent)];
                });
                [NSThread sleepForTimeInterval:0.01];
            }
        });
        
    }else{
        
        NSLog(@"imageView要显示，imageView1要隐藏");
        self.imageView.image = [UIImage imageWithContentsOfFile:path];
        
        dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            for (int i =1; i<=50; i++) {
                __block CGFloat percent = i*i/(50.0*50.0);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.imageView setAlpha:percent];
                    [self.imageView1 setAlpha:(1-percent)];
                });
                [NSThread sleepForTimeInterval:0.01];
            }
        });
    }
    
    self.bgIndex++;
}

-(void)loadSingerPicJson:(NSString *)singerName{
    NSMutableArray *picUrlArray = [[NSMutableArray alloc]init];
    dispatch_queue_t queue = dispatch_queue_create("loadSingerPicJson", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSString *urlStr = [NSString stringWithFormat:@"http://search.dongting.com/artwork/search?artist=%@",singerName];
        NSString *urlEncodeStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlEncodeStr] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
        NSURLSessionDataTask *downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
            if ([data isKindOfClass:[NSURL class]]||data==nil) {
                NSLog(@"结果为null");
                return;
            }
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[json objectForKey:@"msg"] isEqualToString:@"OK"]) {
                NSMutableArray *array = [json mutableArrayValueForKey:@"data"];
                if (array.count>0) {
                     NSDictionary *json1 = [array firstObject];
                    NSMutableArray *picUrlsArray = [json1 mutableArrayValueForKey:@"picUrls"];
                    if (picUrlsArray==nil) {
                        return;
                    }
                    for (int j=0; j<picUrlsArray.count; j++) {
                        NSDictionary *json3 = [picUrlsArray objectAtIndex:j];
                        NSString *urls = [json3 objectForKey:@"picUrl"];
                        [picUrlArray addObject:urls];
                    }
                    self.downloadCount = 0;
                    [self downloadSingerPics:picUrlArray];
                }
            }
        }];
        [downloadTask resume];
    });
}

-(void)downloadSong:(TingSong *)tingSong{
    dispatch_queue_t queue = dispatch_queue_create("downloadSong", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        TingAudition *tingAudition = [tingSong.auditionList lastObject];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:tingAudition.url]];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location,NSURLResponse *response,NSError *error){
            if (location!=nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIButton *downloadBtn = [self.view viewWithTag:107];
                    [downloadBtn setImage:[UIImage imageNamed:@"icon_download_music_ed"] forState:UIControlStateNormal];
                });
                NSLog(@"下载歌曲-%@-完成",tingSong.name);
               
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *urlStr = [FileUtils getSongPathByFileName:[NSString stringWithFormat:@"%@.mp3",tingSong.name]];
                [fileManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:urlStr] error:nil];
                DBHelper *dbHelper = [DBHelper sharedDataBaseHelper];
                [dbHelper insertTable:tingSong];
            }
        }];
        [task resume];
    });
}

-(void)downloadSingerPics:(NSMutableArray *)picUrls{
    if (self.downloadCount>=picUrls.count) {
        NSLog(@"下载全部完成");
        NSArray *picArray = [FileUtils getPicsBySingerName:self.tingSong.singerName];
        if (picArray.count==0) {
            return;
        }
        self.bgIndex = 0;
        if ([FileUtils isExitPath:self.tingSong.singerName]) {
            NSArray *picArray = [FileUtils getPicsBySingerName:self.tingSong.singerName];
            if (picArray!=nil&&picArray.count>0) {
                NSString *path = [[FileUtils getRootSingerPathWithSingerName:self.tingSong.singerName] stringByAppendingPathComponent:picArray[self.bgIndex]];
                self.imageView1.image = [UIImage imageWithContentsOfFile:path];
            }
        }
        if (picArray.count>1) {
            self.bgIndex = 1;
            self.bgTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(changeSingerPic:) userInfo:picArray repeats:YES];
        }
        self.downloadCount = 0;
    }else{
        NSLog(@"一共有%ld张图片需要下载,正在下载第%ld张图片",picUrls.count,self.downloadCount);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:picUrls[self.downloadCount]]];
        NSURLSessionDownloadTask *downTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location,NSURLResponse *response,NSError *error){
            NSString *fullPath = [FileUtils getPicPathBySingerName:self.tingSong.singerName andUrl:picUrls[self.downloadCount]];
            if (location!=nil) {
                [fileManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
                NSLog(@"%@----这是第%ld张图片保存完毕",fullPath,self.downloadCount);
            }else{
                NSLog(@"第%ld张图片sourUrl为nil，跳过",self.downloadCount);
            }
           
            self.downloadCount++;
            [self downloadSingerPics:picUrls];
        }];
        [downTask resume];
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
