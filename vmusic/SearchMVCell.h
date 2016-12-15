//
//  SearchMVCell.h
//  vmusic
//
//  Created by feng yu on 16/12/15.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TingMV.h"

@interface SearchMVCell : UITableViewCell
@property(nonatomic,strong) UIImageView *logoImageView;
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UILabel *singerName;
@property(nonatomic,strong) UILabel *time;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setTingMv:(TingMV *)tingMv;
@end

