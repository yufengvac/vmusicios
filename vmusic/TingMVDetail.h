//
//  TingMVDetail.h
//  vmusic
//
//  Created by feng yu on 16/12/15.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TingMVDetail : NSObject
@property(nonatomic,strong) NSNumber *d_id;
@property(nonatomic,strong) NSNumber *songId;
@property(nonatomic,strong) NSNumber *videoId;
@property(nonatomic,strong) NSString *picUrl;
@property(nonatomic,strong) NSNumber *durationMilliSecond;
@property(nonatomic,strong) NSNumber *duration;
@property(nonatomic,strong) NSNumber *bitRate;
@property(nonatomic,strong) NSString *path;
@property(nonatomic,strong) NSNumber *size;
@property(nonatomic,strong) NSString *suffix;
@property(nonatomic,strong) NSNumber *horizontal;
@property(nonatomic,strong) NSNumber *vertical;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSNumber *type;
@property(nonatomic,strong) NSString *typeDescription;
-(instancetype)initWithDictionary:(NSDictionary *)json;
@end
