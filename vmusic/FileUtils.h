//
//  FileUtils.h
//  vmusic
//
//  Created by feng yu on 16/12/10.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject
+(BOOL)isExitPath:(NSString *)singerName;
+(NSString *)getPicPathBySingerName:(NSString *)singerName andUrl:(NSString *)url;
+(NSArray *)getPicsBySingerName:(NSString *)singerName;
+(NSString *)getRootSingerPathWithSingerName:(NSString *)signerName;
@end
