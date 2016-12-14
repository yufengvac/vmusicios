//
//  SearchAlbumCell.h
//  vmusic
//
//  Created by feng yu on 16/12/14.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TingAlbum.h"

@interface SearchAlbumCell : UITableViewCell
@property(nonatomic,strong) UIImageView *logoImageView;
@property(nonatomic,strong) UILabel *name;
@property(nonatomic,strong) UILabel *singerName;
@property(nonatomic,strong) UILabel *publishDate;
@property(nonatomic,strong) UIImageView *arrow;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setTingAlbum:(TingAlbum *)tingAlbum;

@end
