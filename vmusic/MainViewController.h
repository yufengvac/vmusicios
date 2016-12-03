//
//  MainViewController.h
//  vmusic
//
//  Created by feng yu on 16/11/29.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@protocol AudioPlayerControlDelegate <NSObject>

-(void)play;

@end

@interface MainViewController : UIViewController<UIScrollViewDelegate,UIViewControllerTransitioningDelegate>
@property CGFloat currentRed;
@property CGFloat currentGreen;
@property CGFloat currentBlue;
@property CGFloat currentAlpha;
-(instancetype)initWithFrame:(CGRect)rect;
@property(weak,nonatomic) id<AudioPlayerDelegate> delegate;
@end
