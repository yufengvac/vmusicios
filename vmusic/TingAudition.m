//
//  TingAudition.m
//  vmusic
//
//  Created by feng yu on 16/12/2.
//  Copyright © 2016年 vac. All rights reserved.

//

#import "TingAudition.h"

@implementation TingAudition
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.bitRate forKey:@"bitRate"];
    [aCoder encodeObject:self.duration forKey:@"duration"];
    [aCoder encodeObject:self.size forKey:@"size"];
    [aCoder encodeObject:self.suffix forKey:@"suffix"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.typeDescription forKey:@"description"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self==[super init]) {
        self.bitRate = [aDecoder decodeObjectForKey:@"bitRate"];
        self.duration = [aDecoder decodeObjectForKey:@"duration"];
        self.size = [aDecoder decodeObjectForKey:@"size"];
        self.suffix = [aDecoder decodeObjectForKey:@"suffix"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.typeDescription = [aDecoder decodeObjectForKey:@"description"];
    }
    return self;
}
@end
