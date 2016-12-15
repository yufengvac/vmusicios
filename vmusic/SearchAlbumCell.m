//
//  SearchAlbumCell.m
//  vmusic
//
//  Created by feng yu on 16/12/14.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "SearchAlbumCell.h"
#import "UIColor+ColorChange.h"
#import "UIImageView+WebCache.h"

#define margin 10
#define margin_small 5
#define logoSize 50
#define screenWidth [[UIScreen mainScreen]bounds].size.width

@implementation SearchAlbumCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.logoImageView = [[UIImageView alloc]init];
        
        self.name = [[UILabel alloc]init];
        self.name.font = [UIFont systemFontOfSize:15];
        self.name.textColor = [UIColor blackColor];
        
        self.singerName = [[UILabel alloc]init];
        self.singerName.font = [UIFont systemFontOfSize:12];
        self.singerName.textColor = [UIColor_ColorChange colorWithHexString:@"#949494"];
        
        self.publishDate = [[UILabel alloc]init];
        self.publishDate.font = [UIFont systemFontOfSize:12];
        self.publishDate.textColor = [UIColor_ColorChange colorWithHexString:@"949494"];
        
        self.arrow = [[UIImageView alloc]init];
        self.arrow.image = [UIImage imageNamed:@"img_setting_right_arrow"];
        
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.singerName];
        [self.contentView addSubview:self.publishDate];
        [self.contentView addSubview:self.arrow];
    }
    return self;

}
-(void)setTingAlbum:(TingAlbum *)tingAlbum{
    self.logoImageView.frame = CGRectMake(margin, margin_small, logoSize, logoSize);
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:tingAlbum.picUrl] placeholderImage:[UIImage imageNamed:@"default_bg"] options:SDWebImageContinueInBackground];
    
    self.name.frame = CGRectMake(margin+logoSize+margin, (logoSize+margin_small*2)/3.0-10, screenWidth-(margin*3+logoSize), 20);
    self.name.text = tingAlbum.name;
    
    self.singerName.frame = CGRectMake(margin+logoSize+margin,(logoSize+margin_small*2)/3.0-10+25, screenWidth-(margin*3+logoSize), 20);
    self.singerName.text = tingAlbum.singerName;
    
    CGSize size = [self sizeWithString:tingAlbum.singerName font:[UIFont systemFontOfSize:12] maxSize:self.singerName.frame.size];
    self.publishDate.frame = CGRectMake(margin+logoSize+margin+size.width+5,(logoSize+margin_small*2)/3.0-10+25 ,screenWidth-(margin*3+logoSize+size.width+5), 20);
    self.publishDate.text = tingAlbum.publishDate;
    
    self.arrow.frame = CGRectMake(screenWidth-margin-7, ((logoSize+margin_small*2)-17)/2, 7, 17);
}

- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}
@end
