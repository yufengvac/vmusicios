//
//  TingMVDetail.m
//  vmusic
//
//  Created by feng yu on 16/12/15.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "TingMVDetail.h"

@implementation TingMVDetail
-(instancetype)initWithDictionary:(NSDictionary *)json{
    if (self==[super init]) {
        self.d_id = [json objectForKey:@"id"];
        self.songId = [json objectForKey:@"songId"];
        self.videoId = [json objectForKey:@"videoId"];
        self.picUrl = [json objectForKey:@"picUrl"];
        self.durationMilliSecond = [json objectForKey:@"durationMilliSecond"];
        self.duration = [json objectForKey:@"duration"];
        self.bitRate = [json objectForKey:@"bitRate"];
        self.path = [json objectForKey:@"path"];
        self.size = [json objectForKey:@"size"];
        self.suffix = [json objectForKey:@"suffix"];
        self.horizontal = [json objectForKey:@"horizontal"];
        self.vertical = [json objectForKey:@"vertical"];
        self.url = [json objectForKey:@"url"];
        self.type = [json objectForKey:@"type"];
        self.typeDescription = [json objectForKey:@"typeDescription"];
    }
    return self;
}
@end
