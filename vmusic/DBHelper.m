//
//  DBHelper.m
//  vmusic
//
//  Created by feng yu on 16/12/12.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "DBHelper.h"
static DBHelper* helper = nil;
@implementation DBHelper:NSObject
+ (DBHelper *)sharedDataBaseHelper{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"初始化数据库和表");
        helper = [[DBHelper alloc] init];
        [helper createDataBase];
        [helper createTable];
    });
    return helper;
}

//创建数据库
- (void)createDataBase{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)firstObject];
    NSString *filePath = [doc stringByAppendingPathComponent:@"downloadSong.sqlite"];
    //创建数据库
    self.db = [FMDatabase databaseWithPath:filePath];
}
//创建表
- (void)createTable{
    if ([self.db open]) {
        BOOL result = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS song (id integer PRIMARY KEY AUTOINCREMENT,songId integer NOT NULL, name text NOT NULL, alias text ,singerId integer,singerName text,albumId integer,albumName text,favorites integer,bitRate integer,duration integer,size integer,suffix text,url text NOT NULL,typeDescription text);"];
        if (result) {
            NSLog(@"创建成功");
        }else{
            NSLog(@"创建失败");
        }
        [self.db close];
    }else{
        NSLog(@"数据库打开失败");
    }
}
//插入数据库
-(BOOL)insertTable:(TingSong *)tingSong{
    if ([self.db open]) {
        TingAudition *audition = [tingSong.auditionList lastObject];
        BOOL result = [self.db executeUpdate:@"INSERT INTO song (songId, name , alias , singerId , singerName , albumId , albumName ,favorites,bitRate,duration,size,suffix,url,typeDescription) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?);",tingSong.songId, tingSong.name,tingSong.alias,tingSong.singerId,tingSong.singerName,tingSong.albumId,tingSong.albumName,tingSong.favorites,audition.bitRate,audition.duration,audition.size,audition.suffix,[NSString stringWithFormat:@"song/%@.mp3",tingSong.name],audition.typeDescription];
        if (result) {
            NSLog(@"插入-%@-成功",tingSong.name);
        }else{
            NSLog(@"插入-%@-失败",tingSong.name);
        }
        [self.db close];
        return result;
    }else{
        NSLog(@"插入数据的时候数据库打开失败");
        return NO;
    }
}

-(NSArray *)queryTable{
    NSMutableArray *arr = [NSMutableArray array];
    if ([self.db open]) {
        FMResultSet *set = [self.db executeQuery:@"SELECT * FROM song"];
        while ([set next]) {
            TingSong *tingSong = [[TingSong alloc]init];
            tingSong.songId = [NSNumber numberWithInt:[set intForColumn:@"songId"]];
            tingSong.name = [set stringForColumn:@"name"];
            tingSong.alias = [set stringForColumn:@"alias"];
            tingSong.singerId = [NSNumber numberWithInt:[set intForColumn:@"singerId"]];
            tingSong.singerName = [set stringForColumn:@"singerName"];
            tingSong.albumId = [NSNumber numberWithInt:[set intForColumn:@"albumId"]];
            tingSong.albumName = [set stringForColumn:@"albumName"];
            tingSong.favorites = [NSNumber numberWithInt:[set intForColumn:@"favorites"]];
            
            NSMutableArray *auditonArray = [NSMutableArray array];
            TingAudition *audition = [[TingAudition alloc]init];
            audition.bitRate = [NSNumber numberWithInt:[set intForColumn:@"bitRate"]];
            audition.duration = [NSNumber numberWithInt:[set intForColumn:@"duration"]];
            audition.size = [NSNumber numberWithInt:[set intForColumn:@"size"]];
            audition.suffix = [set stringForColumn:@"suffix"];
            audition.url = [set stringForColumn:@"url"];
            audition.typeDescription = [set stringForColumn:@"typeDescription"];
            [auditonArray addObject:audition];
            
            tingSong.auditionList = auditonArray;
            
            [arr addObject:tingSong];
        }
        [self.db close];
    }
    return arr;
}
-(NSInteger)getDownloadSongCount{
    NSInteger count = 0l;
    if ([self.db open]) {
        FMResultSet *s = [self.db executeQuery:@"SELECT COUNT(*) FROM song"];
        if ([s next]) {
            count = [s intForColumnIndex:0];
        }
        [self.db close];
    }
    return count;
}

@end
