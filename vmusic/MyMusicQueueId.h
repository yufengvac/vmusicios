//
//  SampleQueueId.h
//  ExampleApp
//
//  Created by Thong Nguyen on 20/01/2014.
//  Copyright (c) 2014 Thong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TingSong.h"

@interface MyMusicQueueId : NSObject
@property (readwrite) int count;
@property (readwrite) NSURL* url;
@property (readwrite) TingSong *tingSong;
-(id) initWithUrl:(NSURL*)url andCount:(int)count andTingSong:(TingSong *)tingSong;

@end
