//
//  MusicQueueCellTableViewCell.h
//  vmusic
//
//  Created by feng yu on 16/12/5.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TingSong.h"

@interface MusicQueueCell : UITableViewCell

@property(nonatomic,strong) UILabel *name;
@property(nonatomic,strong) UILabel *line;
@property(nonatomic,strong) UILabel *singerName;
@property(nonatomic,strong) UIButton *favorBtn;
@property(nonatomic,strong) UIButton *deleteBtn;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setData:(TingSong *)tingSong withFocuseIndex:(int)index withRow:(NSInteger)row;
@end
