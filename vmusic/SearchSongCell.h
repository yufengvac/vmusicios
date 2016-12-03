//
//  SearchSongViewController.h
//  vmusic
//
//  Created by feng yu on 16/12/2.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TingSong.h"

@interface SearchSongCell : UITableViewCell
@property(strong,nonatomic) UILabel *nameLabel;
@property(strong,nonatomic) UILabel *singerLabel;
@property(strong,nonatomic) UILabel *point;
@property(strong,nonatomic) UILabel *albumLabel;
@property(strong,nonatomic) UILabel *aliasLabel;

@property(strong,nonatomic) UIImageView *qualityImageView;
@property(strong,nonatomic) UIImageView *mvImageView;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setTingSong:(TingSong *)tingSong;
@property(nonatomic,assign) CGFloat height;
@end
