//
//  TingSong.m
//  vmusic
//
//  Created by feng yu on 16/12/2.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "TingSong.h"

@implementation TingSong

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.songId forKey:@"songId"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.singerId forKey:@"singerId"];
    [coder encodeObject:self.singerName forKey:@"singerName"];
    [coder encodeObject:self.alias forKey:@"alias"];
    [coder encodeObject:self.albumId forKey:@"albumId"];
    [coder encodeObject:self.albumName forKey:@"albumName"];
    [coder encodeObject:self.favorites forKey:@"favorites"];
    [coder encodeObject:self.auditionList forKey:@"auditionList"];
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self ==[super init]) {
        self.songId = [aDecoder decodeObjectForKey:@"songId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.alias = [aDecoder decodeObjectForKey:@"alias"];
        self.singerId = [aDecoder decodeObjectForKey:@"singerId"];
        self.singerName = [aDecoder decodeObjectForKey:@"singerName"];
        self.albumId = [aDecoder decodeObjectForKey:@"albumId"];
        self.albumName = [aDecoder decodeObjectForKey:@"albumName"];
        self.favorites = [aDecoder decodeObjectForKey:@"favorites"];
        self.auditionList = [aDecoder decodeObjectForKey:@"auditionList"];
    }
    return self;
}
@end
