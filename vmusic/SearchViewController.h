//
//  SearchViewController.h
//  vmusic
//
//  Created by feng yu on 16/11/30.
//  Copyright © 2016年 vac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TingSong.h"

@protocol AudioPlayerDelegate <NSObject>

-(void)setTingSongQueue:(NSMutableArray *)tingSongArray;
-(void)toogglePlay:(TingSong *)tingSong;
@end

@interface SearchViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property(weak,nonatomic) id<AudioPlayerDelegate> delegate;
@end
