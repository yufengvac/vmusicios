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
        
        self.indicatorArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"indicator_1"],[UIImage imageNamed:@"indicator_2"],[UIImage imageNamed:@"indicator_3"], nil];
        self.indicator = [[UIImageView alloc]init];
        
        self.favorBtn = [[UIButton alloc]init];
        [self.favorBtn setImage:[UIImage imageNamed:@"icon_favor_no"] forState:UIControlStateNormal];
        
        self.deleteBtn = [[UIButton alloc]init];
        [self.deleteBtn setImage:[UIImage imageNamed:@"icon_clear_edit"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.favorBtn];
        [self.contentView addSubview:self.deleteBtn];
        [self.contentView addSubview:self.indicator];
    }
    return self;
}
-(void)setData:(TingSong *)tingSong withSongId:(NSNumber *)songId withState:(NSInteger)state{
    self.name.frame = CGRectMake(margin*1.5,(btnSize-20)/2 , screenWidth/2, 20);
    self.name.text = tingSong.name;
    
    CGSize size = [self sizeWithString:tingSong.name font:[UIFont systemFontOfSize:15] maxSize:self.name.frame.size];
    
//     CGSize size = [self boundingRectWithSize:tingSong.name font:[UIFont systemFontOfSize:11] maxSize:self.name.frame.size];
    
    CGFloat left = margin*1.5 +size.width+2;
    self.line.frame = CGRectMake(left,(btnSize-1)/2 ,6 ,1 );
    
    self.singerName.frame = CGRectMake(left+10, (btnSize-20)/2, screenWidth-left-btnSize*2, 20);
    self.singerName.text = tingSong.singerName;
    
    CGSize singerNameSize = [self sizeWithString:tingSong.singerName font:[UIFont systemFontOfSize:13] maxSize:self.singerName.frame.size];
    self.indicator.frame = CGRectMake(left+10+singerNameSize.width+10, 12.5, btnSize-25, btnSize-25);
    
    self.favorBtn.frame = CGRectMake(screenWidth-btnSize*2, 0, btnSize, btnSize);
    self.deleteBtn.frame= CGRectMake(screenWidth-btnSize, 0, btnSize, btnSize);
    
    if (tingSong.auditionList.count==0) {
        self.name.enabled = NO;
        self.singerName.enabled = NO;
    }else{
        self.name.enabled = YES;
        self.name.enabled = YES;
    }
    
    if ([tingSong.songId integerValue]==[songId integerValue]) {
        self.name.textColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0];
        self.singerName.textColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:0.7];
        self.line.backgroundColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0];
        
        self.indicator.hidden = NO;
        if (state==0) {
            self.indicator.image = [UIImage imageNamed:@"indicator_1"];
            [self.indicator stopAnimating];
        }else{
            self.indicator.animationImages = self.indicatorArray;
            self.indicator.animationDuration = 0.4;
            [self.indicator startAnimating];
        }
       
        
    }else{
        self.name.textColor = [UIColor blackColor];
        self.singerName.textColor = [UIColor_ColorChange colorWithHexString:@"#949494"];
        self.line.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#949494"];
        self.indicator.hidden = YES;
    }
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
