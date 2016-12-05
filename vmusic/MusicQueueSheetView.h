//
//  MusicQueueSheetView.h
//  vmusic
//
//  Created by feng yu on 16/12/5.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayerDelegate.h"

@interface MusicQueueSheetView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) NSMutableArray *dataArray;
-(void)showInView:(UIView *)view;
@property(weak,nonatomic) id<AudioPlayerDelegate> delegate;
@end
