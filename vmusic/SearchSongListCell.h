//
//  SearchSongListCell.h
//  vmusic
//
//  Created by feng yu on 16/12/15.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TingSongList.h"

@interface SearchSongListCell : UITableViewCell
@property(nonatomic,strong) UIImageView *logoImageView;
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UILabel *count;
@property(nonatomic,strong) UIImageView *arrow;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setTingSongList:(TingSongList *)tingSongList;
@end
