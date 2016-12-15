//
//  TingMV.m
//  vmusic
//
//  Created by feng yu on 16/12/15.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "TingMV.h"
#import "TingMVDetail.h"

@implementation TingMV
-(instancetype)initWithDictionary:(NSDictionary *)json{
    if (self==[super init]) {
        self.mv_id = [json objectForKey:@"id"];
        self.songId = [json objectForKey:@"songId"];
        self.videoName = [json objectForKey:@"videoName"];
        self.singerName = [json objectForKey:@"singerName"];
        self.picUrl = [json objectForKey:@"picUrl"];
        self.pickCount = [json objectForKey:@"pickCount"];
        self.bulletCount = [json objectForKey:@"bulletCount"];
        NSMutableArray *array = [json mutableArrayValueForKey:@"mvList"];
        
        NSMutableArray *mvlists = [NSMutableArray array];
        if (array.count>0) {
            for (int i=0; i<array.count; i++) {
                NSDictionary *json1 = [array objectAtIndex:i];
                TingMVDetail *tingMvDetail = [[TingMVDetail alloc]initWithDictionary:json1];
                [mvlists addObject:tingMvDetail];
            }
        }
        self.mvList = mvlists;
    }
    return self;
}
@end
