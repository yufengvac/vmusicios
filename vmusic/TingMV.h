//
//  TingMV.h
//  vmusic
//
//  Created by feng yu on 16/12/15.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TingMV : NSObject
@property(nonatomic,strong) NSNumber *mv_id;
@property(nonatomic,strong) NSNumber *songId;
@property(nonatomic,strong) NSString *videoName;
@property(nonatomic,strong) NSString *singerName;
@property(nonatomic,strong) NSString *picUrl;
@property(nonatomic,strong) NSNumber *pickCount;
@property(nonatomic,strong) NSNumber *bulletCount;
@property(nonatomic,strong) NSMutableArray *mvList;
-(instancetype)initWithDictionary:(NSDictionary *)json;
@end
