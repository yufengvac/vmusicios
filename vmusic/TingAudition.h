//
//  TingAudition.h
//  vmusic
//
//  Created by feng yu on 16/12/2.
//  Copyright © 2016年 vac. All rights reserved.
//
//
//"bitRate": 32,
//"duration": 223056,
//"size": 928244,
//"suffix": "m4a",
//"url": "http://om32.alicdn.com/169/7169/436317/1770153970_1479876601708.m4a?auth_key=54209866939c4926a182fb2f31d7c768-1481252400-0-null",
//"typeDescription": "流畅品质"

#import <Foundation/Foundation.h>

@interface TingAudition : NSObject
@property(nonatomic,assign) NSNumber *bitRate;
@property(nonatomic,assign) NSNumber *duration;
@property(nonatomic,assign) NSNumber *size;
@property(nonatomic,strong) NSString *suffix;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *typeDescription;
@end
