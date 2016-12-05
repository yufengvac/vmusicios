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
-(void)toogglePlay:(TingSong *)tingSong index:(int) index;
@end
@interface AudioPlayerDelegate : NSObject

@end
