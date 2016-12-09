//
//  AppDelegate.h
//  vmusic
//
//  Created by feng yu on 16/11/29.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "AudioPlayerDelegate.h"
#import "STKAudioPlayer.h"

@protocol OtherSongPlayDelegate <NSObject>

-(void)newSongWillPlay:(TingSong *)oldTingSong andNewSong:(TingSong *)newSong;
-(void)newSongDidPlay:(TingSong *)newSong;

@end
@interface AppDelegate : UIResponder <UIApplicationDelegate,AudioPlayerControlDelegate,AudioPlayerDelegate,STKAudioPlayerDelegate>
@property (strong, nonatomic) UIWindow *window;

@property (weak,nonatomic) id<OtherSongPlayDelegate> otherSongPlayDelegate;
@end

