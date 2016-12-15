//
//  TingSongList.h
//  vmusic
//
//  Created by feng yu on 16/12/15.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TingSongList : NSObject
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *desc;
@property(nonatomic,copy) NSNumber *list_id;
@property(nonatomic,copy) NSNumber *quan_id;
@property(nonatomic,copy) NSString *song_list;
@property(nonatomic,copy) NSNumber *create_at;
@property(nonatomic,copy) NSNumber *comment_count;
@property(nonatomic,copy) NSNumber *listen_count;
@property(nonatomic,copy) NSString *pic_url;
@property(nonatomic,copy) NSString *author;
@end
