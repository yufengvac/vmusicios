//
//  SearchSongViewController.m
//  vmusic
//
//  Created by feng yu on 16/12/2.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "SearchSongCell.h"
#import "TingSong.h"
#import "UIColor+ColorChange.h"
#define screenWidth [[UIScreen mainScreen]bounds].size.width
#define margin 10
#define rightSize 70

@interface SearchSongCell ()
@property NSMutableArray *data;
@end

@implementation SearchSongCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, margin, screenWidth-rightSize, 20)];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.nameLabel];
        
        self.singerLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, 20+margin*1.5, 150, 20)];
        self.singerLabel.textColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0];
        self.singerLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.singerLabel];
        
        
        self.point = [[UILabel alloc]initWithFrame:CGRectMake(50, 20+margin*1.5 , 5, 20)];
        self.point.textColor = [UIColor blackColor];
        self.point.text = @"·";
        self.point.font = [UIFont systemFontOfSize:12];
        self.point.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.point];
        
        self.albumLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 20,150 , 20)];
        self.albumLabel.textColor = [UIColor_ColorChange colorWithHexString:@"#949494"];
        self.albumLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.albumLabel];
        
        self.aliasLabel = [[UILabel alloc]init];
        self.aliasLabel.textColor = [UIColor_ColorChange colorWithHexString:@"#949494"];;
        self.aliasLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.aliasLabel];
        
        self.qualityImageView = [[UIImageView alloc]init];
        self.mvImageView = [[UIImageView alloc]init];
    }
    return self;
}
-(void)setTingSong:(TingSong *)tingSong{
    self.nameLabel.text = tingSong.name;
    self.singerLabel.text= tingSong.singerName;
    self.albumLabel.text = tingSong.albumName;
    
    self.nameLabel.frame = CGRectMake(margin, margin, screenWidth-rightSize, 20);
    self.singerLabel.frame = CGRectMake(margin,20+margin*1.5, 150, 20);
    
    CGSize reallySinger = [self sizeWithString:tingSong.singerName font:[UIFont systemFontOfSize:12] maxSize:self.singerLabel.frame.size];
    self.point.frame = CGRectMake(margin+reallySinger.width,20+margin*1.5 , 5, 20);
    self.albumLabel.frame = CGRectMake(margin+reallySinger.width+5,20+ margin*1.5, screenWidth-(margin+reallySinger.width+5+rightSize), 20);
    
    if ([tingSong.alias isKindOfClass:[NSNull class]]||tingSong.alias==nil||tingSong.alias.length==0) {
        [self.aliasLabel removeFromSuperview];
        self.height = 60;
    }else{
        self.aliasLabel.frame = CGRectMake(margin,40+ margin*1.5 , screenWidth-rightSize, 20);
        self.height = 80;
        self.aliasLabel.text = tingSong.alias;
        [self.aliasLabel removeFromSuperview];
        [self.contentView addSubview:self.aliasLabel];
    }
    
    CGSize reallyTing = [self sizeWithString:tingSong.name font:[UIFont systemFontOfSize:15] maxSize:self.nameLabel.frame.size];
    NSMutableArray *audionList = tingSong.auditionList;
    if (audionList.count>0) {
        TingAudition *audition = [audionList lastObject];
        [self.qualityImageView removeFromSuperview];
        if ([audition.bitRate integerValue]==320) {
            self.qualityImageView.frame = CGRectMake(margin+reallyTing.width, margin-6, 32, 32);
            self.qualityImageView.image = [UIImage imageNamed:@"icon_hq"];
            [self.contentView addSubview:self.qualityImageView];
        }
        self.nameLabel.enabled = YES;
        self.singerLabel.enabled = YES;
        self.albumLabel.enabled = YES;

    }else{
        self.nameLabel.enabled = NO;
        self.singerLabel.enabled = NO;
        self.albumLabel.enabled = NO;
    }
    
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
