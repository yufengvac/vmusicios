//
//  SearchMVCell.m
//  vmusic
//
//  Created by feng yu on 16/12/15.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "SearchMVCell.h"
#import "UIColor+ColorChange.h"
#import "TingMVDetail.h"
#import "UIImageView+WebCache.h"

#define margin 10
#define margin_small 5
#define logoHeight 70
#define logoWidth 100
#define screenWidth [[UIScreen mainScreen]bounds].size.width

@implementation SearchMVCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.logoImageView = [[UIImageView alloc]init];
        
        self.title = [[UILabel alloc]init];
        self.title.font = [UIFont systemFontOfSize:15];
        self.title.textColor = [UIColor blackColor];
        
        self.singerName = [[UILabel alloc]init];
        self.singerName.font = [UIFont systemFontOfSize:12];
        self.singerName.textColor = [UIColor_ColorChange colorWithHexString:@"#949494"];
        
        
        self.time = [[UILabel alloc]init];
        self.time.font = [UIFont systemFontOfSize:12];
        self.time.textColor = [UIColor_ColorChange colorWithHexString:@"#949494"];
        
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.singerName];
        [self.contentView addSubview:self.time];
    }
    return self;
}
-(void)setTingMv:(TingMV *)tingMv{
    self.logoImageView.frame = CGRectMake(margin, margin_small, logoWidth, logoHeight);
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:tingMv.picUrl] placeholderImage:[UIImage imageNamed:@"default_bg"] options:SDWebImageContinueInBackground];
    
    self.title.frame = CGRectMake(margin+logoWidth+margin, (logoHeight+margin_small*2)/3.0-10, screenWidth-(margin*3+logoWidth), 20);
    self.title.text = tingMv.videoName;
    
    self.singerName.frame = CGRectMake(margin+logoWidth+margin,(logoHeight+margin_small*2)/3.0-10+25, screenWidth-(margin*3+logoWidth), 20);
    self.singerName.text = tingMv.singerName;
    
    CGSize size = [self sizeWithString:tingMv.singerName font:[UIFont systemFontOfSize:12] maxSize:self.singerName.bounds.size];
    self.time.frame = CGRectMake(margin+logoWidth+margin+5+size.width, (logoHeight+margin_small*2)/3.0-10+25, 100, 20);
    TingMVDetail *tmd = [tingMv.mvList lastObject];
    self.time.text = [self formatTimeFromSeconds:[tmd.duration integerValue]/1000.0];

}
-(NSString*) formatTimeFromSeconds:(NSInteger)totalSeconds{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
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
