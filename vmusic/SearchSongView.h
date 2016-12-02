//
//  SearchSongViewController.h
//  vmusic
//
//  Created by feng yu on 16/12/2.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSongView : UITableViewCell
@property(strong,nonatomic) UILabel *nameLabel;
@property(strong,nonatomic) UILabel *singerLabel;
@property(strong,nonatomic) UILabel *albumLabel;
//-(instancetype)initWithFrame:(CGRect)frame andTingSong:(TingSong *)tingSong;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
