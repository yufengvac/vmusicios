//
//  AudioPlayerDelegate.h
//  vmusic
//
//  Created by feng yu on 16/12/5.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TingSong.h"
@protocol AudioPlayerDelegate <NSObject>

-(void)setTingSongQueue:(NSMutableArray *)tingSongArray;
-(NSInteger)initPlay:(NSNumber *)songId index:(int) index isLocal:(BOOL)isLocalMsuic;
-(TingSong *)getCurrentTingSong;
-(void)togglePlayPause;
-(void)playNext;
-(void)playPre;
@end
@interface AudioPlayerDelegate : NSObject

@end
