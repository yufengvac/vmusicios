//
//  TingSongUtil.h
//  vmusic
//
//  Created by yufengvac on 2016/12/4.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TingSongUtil : NSObject
+(int)getIndexOfMusicQueue:(NSMutableArray *)musicQueueArray bySongId:(NSNumber *)songId;
@end
