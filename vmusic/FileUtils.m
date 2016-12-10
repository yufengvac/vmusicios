//
//  FileUtils.m
//  vmusic
//
//  Created by feng yu on 16/12/10.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "FileUtils.h"

@implementation FileUtils
+(BOOL)isExitPath:(NSString *)singerName{
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *rootPath = [array lastObject];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [rootPath stringByAppendingPathComponent:@"photoGraphic"];
    BOOL isDir;
    if ([fileManager fileExistsAtPath:path isDirectory:&isDir]&&isDir) {
        NSLog(@"图片目录已经存在---%@",path);
        NSString *singerPath = [path stringByAppendingPathComponent:singerName];
        BOOL isDir1;
        if ([fileManager fileExistsAtPath:singerPath isDirectory:&isDir1]&&isDir1) {
            NSLog(@"歌手目录已经存在---%@",singerPath);
            return YES;
        }else{
            return NO;
        }
    }else{
        NSLog(@"图片目录不存在--创建目录%@",path);
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        return NO;
    }
}
+(NSString *)getPicPathBySingerName:(NSString *)singerName andUrl:(NSString *)url{

    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *rootPath = [array lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"photoGraphic/%@",singerName]];
    BOOL isDir;
    if (!([fileManager fileExistsAtPath:path isDirectory:&isDir]&&isDir)) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"%@目录不存在，去创建个%@",singerName,path);
    }
    NSString *filePath = [path stringByAppendingPathComponent:[self getFileNameOfUrl:url]];
    return filePath;
}

+(NSArray *)getPicsBySingerName:(NSString *)singerName{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"photoGraphic/%@",singerName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];

   return [fileManager contentsOfDirectoryAtPath:path error:nil];
}

+(NSString *)getRootSingerPathWithSingerName:(NSString *)singerName{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    return [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"photoGraphic/%@",singerName]];
}

+(NSString *)getFileNameOfUrl:(NSString *)url{
    
    NSString *filename = [[NSString alloc] init];
    
    NSArray *SeparatedArray = [url componentsSeparatedByString:@"/"];
    
    filename = [SeparatedArray lastObject];
    
    NSLog(@"文件名字是：%@",filename);
    return filename;
}
@end
