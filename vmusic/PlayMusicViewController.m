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
#define screenWidth  [[UIScreen mainScreen]bounds].size.width
#define screenHeight  [[UIScreen mainScreen]bounds].size.height
#define statusBarHeight 15
#define margin 10
#define bottomHeight 145

@interface PlayMusicViewController ()
@property(strong,nonatomic) TingSong *tingSong;
@property(weak,nonatomic) NSTimer *progressTimer;
@property(strong,nonatomic) UISlider *slider;
@property(strong,nonatomic) UILabel *curentTimerLabel;
@end

@implementation PlayMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tingSong = [self.delegate getCurrentTingSong];
   
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.tag =1;
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
        case 102:
            [self.delegate togglePlayPause];
            if ([self.audioPlayer state]==STKAudioPlayerStatePlaying) {
                [btn setImage:[UIImage imageNamed:@"icon_play_pause"] forState:UIControlStateNormal];
            }else{
                [btn setImage:[UIImage imageNamed:@"icon_play_play"] forState:UIControlStateNormal];
            }
            break;
        case 103:
            [self.delegate playPre];
            break;
        case 104:
            [self.delegate playNext];
            break;
        default:
            break;
    }
}
-(void)sliderAction:(UISlider *)slider{
    CGFloat value =  slider.value;
    [self.audioPlayer seekToTime:[self.audioPlayer duration]*value];
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
    [self performSelector:@selector(notifi) withObject:nil afterDelay:0.25f];

    [self.progressTimer setFireDate:[NSDate distantFuture]];
}
-(void)viewWillAppear:(BOOL)animated{
    if (self.progressTimer==nil) {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUi) userInfo:nil repeats:YES];
    }
    [self.progressTimer setFireDate:[NSDate distantPast]];
}
-(void)viewDidAppear:(BOOL)animated{
    [self loadSingerPicJson:self.tingSong.singerName];
}
-(void)notifi{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showBottom" object:self];
}

-(void)loadSingerPicJson:(NSString *)singerName{
    NSMutableArray *picArray = [[NSMutableArray alloc]init];
    dispatch_queue_t queue = dispatch_queue_create("loadSingerPicJson", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSString *urlStr = [NSString stringWithFormat:@"http://search.dongting.com/artwork/search?artist=%@",singerName];
        NSString *urlEncodeStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlEncodeStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
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
                        [picArray addObject:[NSURL URLWithString:urls]];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImageView *bgImageView = [self.view viewWithTag:1];
//                        [bgImageView sd_setImageWithURL:[NSURL URLWithString:picArray[0]]];
                        NSArray *picArray1 = [picArray copy];
                        [bgImageView setAnimationDuration:4*30];
                        [bgImageView sd_setAnimationImagesWithURLs:picArray1];
                        
                    });
                    
                }
            }
        }];
        [downloadTask resume];
    });
}

- (UIImage*) getBrighterImage:(UIImage *)originalImage
{
    UIImage *brighterImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:originalImage.CGImage];
    
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:inputImage forKey:kCIInputImageKey];
    [lighten setValue:@(0.3) forKey:@"inputBrightness"];
    [lighten setValue:@(2.2) forKey:@"inputContrast"];
    
    CIImage *result = [lighten valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    brighterImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return brighterImage;
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
