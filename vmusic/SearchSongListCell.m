//
//  SearchSongListCell.m
//  vmusic
//
//  Created by feng yu on 16/12/15.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "SearchSongListCell.h"
#import "UIColor+ColorChange.h"
#import "UIImageView+WebCache.h"

#define margin 10
#define margin_small 5
#define logoSize 50
#define screenWidth [[UIScreen mainScreen]bounds].size.width

@implementation SearchSongListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.logoImageView = [[UIImageView alloc]init];
        
        self.title = [[UILabel alloc]init];
        self.title.font = [UIFont systemFontOfSize:15];
        self.title.textColor = [UIColor blackColor];
        
        self.count = [[UILabel alloc]init];
        self.count.font = [UIFont systemFontOfSize:12];
        self.count.textColor = [UIColor_ColorChange colorWithHexString:@"#949494"];
        
        
        self.arrow = [[UIImageView alloc]init];
        self.arrow.image = [UIImage imageNamed:@"img_setting_right_arrow"];
        
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.count];
        [self.contentView addSubview:self.arrow];
    }
    return self;
}

-(void)setTingSongList:(TingSongList *)tingSongList{
    self.logoImageView.frame = CGRectMake(margin, margin_small, logoSize, logoSize);
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:tingSongList.pic_url] placeholderImage:[UIImage imageNamed:@"default_bg"] options:SDWebImageContinueInBackground];
    
    self.title.frame = CGRectMake(margin+logoSize+margin, (logoSize+margin_small*2)/3.0-10, screenWidth-(margin*3+logoSize), 20);
    self.title.text = tingSongList.title;
    
    self.count.frame = CGRectMake(margin+logoSize+margin,(logoSize+margin_small*2)/3.0-10+25, screenWidth-(margin*3+logoSize), 20);
    NSArray *array = [tingSongList.title componentsSeparatedByString:@","];
    self.count.text = [NSString stringWithFormat:@"%ld首",array.count];

    
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
