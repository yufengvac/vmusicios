//
//  SampleQueueId.m
//  ExampleApp
//
//  Created by Thong Nguyen on 20/01/2014.
//  Copyright (c) 2014 Thong Nguyen. All rights reserved.
//

#import "MyMusicQueueId.h"

@implementation MyMusicQueueId

-(id) initWithUrl:(NSURL*)url andCount:(int)count andTingSong:(TingSong *)tingSong
{
    if (self = [super init])
    {
        self.url = url;
        self.count = count;
        self.tingSong = tingSong;
    }
    
    return self;
}

-(BOOL) isEqual:(id)object
{
    if (object == nil)
    {
        return NO;
    }
    
    if ([object class] != [MyMusicQueueId class])
    {
        return NO;
    }
    
    return [((MyMusicQueueId*)object).url isEqual: self.url] && ((MyMusicQueueId*)object).count == self.count;
}

-(NSString*) description
{
    return [self.url description];
}

@end
