//
//  TingSong.h
//  vmusic
//
//  Created by feng yu on 16/12/2.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface TingSong : NSObject
@property(nonatomic,assign) NSInteger songId;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *alias;
@property(nonatomic,assign) NSInteger singerId;
@property(nonatomic,strong) NSString *singerName;
@property(nonatomic,assign) NSInteger albumId;
@property(nonatomic,strong) NSString *albumName;
@property(nonatomic,assign) NSInteger favorites;
@property(nonatomic,strong) NSMutableArray *auditionList;
@end
