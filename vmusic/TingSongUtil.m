//
//  TingSongUtil.m
//  vmusic
//
//  Created by yufengvac on 2016/12/4.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "TingSongUtil.h"
#import "TingSong.h"

@implementation TingSongUtil
+(int)getIndexOfMusicQueue:(NSMutableArray *)musicQueueArray bySongId:(NSNumber *)songId{
    int index = -1;
    if (musicQueueArray==nil||musicQueueArray.count==0) {
        return index;
    }
    NSInteger song_id = [songId integerValue];
    for (int i=0; i<musicQueueArray.count; i++) {
        TingSong *tingSong = musicQueueArray[i];
        if ([tingSong.songId integerValue]==song_id) {
            index = i;
            break;
        }
    }
    return index;
}
@end
