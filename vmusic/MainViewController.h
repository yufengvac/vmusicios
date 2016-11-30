//
//  MainViewController.h
//  vmusic
//
//  Created by feng yu on 16/11/29.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AudioPlayerControlDelegate <NSObject>

-(void)play;

@end

@interface MainViewController : UIViewController<UIScrollViewDelegate,UIViewControllerTransitioningDelegate>
@property CGFloat currentRed;
@property CGFloat currentGreen;
@property CGFloat currentBlue;
@property CGFloat currentAlpha;
@property (readwrite, unsafe_unretained) id<AudioPlayerControlDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)rect;
@end
