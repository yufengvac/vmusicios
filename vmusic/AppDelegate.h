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
@interface AppDelegate : UIResponder <UIApplicationDelegate,AudioPlayerControlDelegate,AudioPlayerDelegate,STKAudioPlayerDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

