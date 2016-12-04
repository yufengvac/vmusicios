//
//  TingSong.h
//  vmusic
//
//  Created by feng yu on 16/12/2.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TingAudition.h"
#import "UIKit/UIKit.h"

@interface TingSong : NSObject<NSCoding>
@property(nonatomic,assign) NSNumber *songId;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *alias;
@property(nonatomic,assign) NSNumber *singerId;
@property(nonatomic,strong) NSString *singerName;
@property(nonatomic,assign) NSNumber *albumId;
@property(nonatomic,strong) NSString *albumName;
@property(nonatomic,assign) NSNumber *favorites;
@property(nonatomic,strong) NSMutableArray *auditionList;
@end
