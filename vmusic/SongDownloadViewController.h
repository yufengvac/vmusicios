//
//  SongDownloadViewController.h
//  vmusic
//
//  Created by feng yu on 16/12/13.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayerDelegate.h"
@interface SongDownloadViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(weak,nonatomic) id<AudioPlayerDelegate> delegate;
@end
