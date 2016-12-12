//
//  DBHelper.h
//  vmusic
//
//  Created by feng yu on 16/12/12.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "TingSong.h"
@interface DBHelper : NSObject
+ (DBHelper *)sharedDataBaseHelper;
-(BOOL)insertTable:(TingSong *)tingSong;
-(NSArray *)queryTable;
-(NSInteger)getDownloadSongCount;
@property (strong,nonatomic) FMDatabase *db;
@end
