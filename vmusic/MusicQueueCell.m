//
//  MusicQueueCellTableViewCell.m
//  vmusic
//
//  Created by feng yu on 16/12/5.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "MusicQueueCell.h"
#import "UIColor+ColorChange.h"
#define margin 10
#define screenWidth [[UIScreen mainScreen]bounds].size.width
#define btnSize 45

@implementation MusicQueueCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self ==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.name = [[UILabel alloc]init];
        self.name.textColor = [UIColor blackColor];
        self.name.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.name];
        
        self.singerName = [[UILabel alloc]init];
        self.singerName.textColor = [UIColor_ColorChange colorWithHexString:@"#949494"];
        self.singerName.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.singerName];
        
        self.line = [[UILabel alloc]init];
        self.line.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#949494"];
        self.line.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.line];
        
        self.favorBtn = [[UIButton alloc]init];
        [self.favorBtn setImage:[UIImage imageNamed:@"icon_favor_no"] forState:UIControlStateNormal];
        
        self.deleteBtn = [[UIButton alloc]init];
        [self.deleteBtn setImage:[UIImage imageNamed:@"icon_clear_edit"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.favorBtn];
        [self.contentView addSubview:self.deleteBtn];
    }
    return self;
}
-(void)setData:(TingSong *)tingSong{
    self.name.frame = CGRectMake(margin*1.5,(btnSize-20)/2 , screenWidth/2, 20);
    self.name.text = tingSong.name;
    
    CGSize size = [self sizeWithString:tingSong.name font:[UIFont systemFontOfSize:15] maxSize:self.name.frame.size];
    
//     CGSize size = [self boundingRectWithSize:tingSong.name font:[UIFont systemFontOfSize:11] maxSize:self.name.frame.size];
    
    CGFloat left = margin*1.5 +size.width+2;
    self.line.frame = CGRectMake(left,(btnSize-1)/2 ,6 ,1 );
    
    self.singerName.frame = CGRectMake(left+10, (btnSize-20)/2, screenWidth-left-btnSize*2, 20);
    self.singerName.text = tingSong.singerName;
    
    self.favorBtn.frame = CGRectMake(screenWidth-btnSize*2, 0, btnSize, btnSize);
    self.deleteBtn.frame= CGRectMake(screenWidth-btnSize, 0, btnSize, btnSize);
}

- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}


- (CGSize)boundingRectWithSize:(NSString *)str font:(UIFont *)font maxSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [str boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}
@end
