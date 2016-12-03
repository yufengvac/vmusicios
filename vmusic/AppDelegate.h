//
//  AppDelegate.h
//  vmusic
//
//  Created by feng yu on 16/11/29.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "SearchViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,AudioPlayerControlDelegate,AudioPlayerDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

