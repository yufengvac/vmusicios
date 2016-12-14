//
//  TingAlbum.h
//  vmusic
//
//  Created by feng yu on 16/12/14.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TingAlbum : NSObject
@property(nonatomic,strong) NSNumber *albumId;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *AlbumDescription;
@property(nonatomic,strong) NSString *singerName;
@property(nonatomic,strong) NSString *picUrl;
@property(nonatomic,strong) NSNumber *publishYear;
@property(nonatomic,strong) NSString *publishDate;
@property(nonatomic,strong) NSString *lang;
@property(nonatomic,strong) NSMutableArray *songs;
@property(nonatomic,strong) NSNumber *status;
@property(nonatomic,strong) NSNumber *isExclusive;
@end
