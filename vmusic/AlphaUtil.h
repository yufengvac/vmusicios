//
//  AlphaUtil.h
//  vmusic
//
//  Created by feng yu on 16/12/10.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIkit.h"
@interface AlphaUtil : NSObject
@property UIImageView *showImageView;
@property UIImageView *hideImageView;
-(instancetype)initWithShowImageView:(UIImageView *)showImageView andHideImageView:(UIImageView *)hideImageView;
+(void)toExecuteWithShowImageView:(UIImageView *)showImageView andHideImageView:(UIImageView *)hideImageView;
@end
