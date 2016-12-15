//
//  PlayMusicViewController.h
//  vmusic
//
//  Created by feng yu on 16/12/7.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayerDelegate.h"
#import "STKAudioPlayer.h"
#import "AppDelegate.h"

@interface PlayMusicViewController : UIViewController<OtherSongPlayDelegate,UIGestureRecognizerDelegate>
@property(weak,nonatomic) id<AudioPlayerDelegate> delegate;
@property(weak,nonatomic) STKAudioPlayer *audioPlayer;
@end
