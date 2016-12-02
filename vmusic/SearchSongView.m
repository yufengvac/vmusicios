//
//  SearchSongViewController.m
//  vmusic
//
//  Created by feng yu on 16/12/2.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "SearchSongView.h"
#import "TingSong.h"
#define screenWidth [[UIScreen mainScreen]bounds].size.width

@interface SearchSongView ()
@property NSMutableArray *data;
@end

@implementation SearchSongView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.nameLabel];
        
        self.singerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 50, 20)];
        self.singerLabel.textColor = [UIColor blackColor];
        self.singerLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.singerLabel];
        
        UILabel *point = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, 5, 5)];
        point.textColor = [UIColor blackColor];
        point.text = @"·";
        point.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:point];
        
        self.albumLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 50,150 , 20)];
        self.albumLabel.textColor = [UIColor blackColor];
        self.albumLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.albumLabel];
    }
    return self;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.backgroundColor = [UIColor lightGrayColor];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.nameLabel];
        
        self.singerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 50, 20)];
        self.singerLabel.textColor = [UIColor blackColor];
        self.singerLabel.font = [UIFont systemFontOfSize:12];
        self.singerLabel.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.singerLabel];
        
        UILabel *point = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, 5, 20)];
        point.textColor = [UIColor blackColor];
        point.text = @"·";
        point.font = [UIFont systemFontOfSize:12];
        point.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:point];
        
        self.albumLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 20,150 , 20)];
        self.albumLabel.textColor = [UIColor blackColor];
        self.albumLabel.font = [UIFont systemFontOfSize:12];
        self.albumLabel.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.albumLabel];
        CGRect rect = CGRectMake(0, 0, screenWidth, 500);
        self.frame = rect;
    }
    return self;
}

/**
 161  *  计算文本的宽高
 162  *
 163  *  @param str     需要计算的文本
 164  *  @param font    文本显示的字体
 165  *  @param maxSize 文本显示的范围
 166  *
 167  *  @return 文本占用的真实宽高
 168  */
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
     // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
     return size;
}


@end
