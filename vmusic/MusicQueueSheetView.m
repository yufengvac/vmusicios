
//
//  MusicQueueSheetView.m
//  vmusic
//
//  Created by feng yu on 16/12/5.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "MusicQueueSheetView.h"
#import "MusicQueueCell.h"
#import "UIColor+ColorChange.h"
#define bottomHeight ([[UIScreen mainScreen]bounds].size.height*0.6)
#define screenHeight [[UIScreen mainScreen]bounds].size.height
#define screenWidth [[UIScreen mainScreen]bounds].size.width
#define topBarHeight 50
#define bottomBarHeight 50
#define margin 10

@implementation MusicQueueSheetView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        [self initContent];
    }
    return self;
}
-(void)initContent{
    self.frame = CGRectMake(0, 0,screenWidth, screenHeight);
    
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    
    if (self.contentView == nil){
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight - bottomHeight, screenWidth, bottomHeight)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth/2, topBarHeight)];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        btn.tag = 101;
        [self.contentView addSubview:btn];
        
        UIImageView *modeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(margin, (topBarHeight-25)/2, 25, 25)];
        modeImageView.tag = 301;
        modeImageView.image = [UIImage imageNamed:@"icon_mode_all_repeat"];
        [btn addSubview:modeImageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(margin+35, 0, screenWidth/2, topBarHeight)];
        label.tag = 201;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentLeft;
        
        label.text =[NSString stringWithFormat:@"列表循环(%ld首)",self.dataArray.count];
        [btn addSubview:label];
        //        NSInteger mode = [[NSUserDefaults standardUserDefaults]integerForKey:@"mode"];
        //        [self updatePlayModeWithMode:mode andBtn:btn];
        
        CGFloat btnWitdh = 40;
        
        UIButton *downloadBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth-margin-btnWitdh*3, (bottomBarHeight-btnWitdh)/2, btnWitdh, btnWitdh)];
        [downloadBtn setImage:[UIImage imageNamed:@"icon_download"] forState:UIControlStateNormal];
        [btn addSubview:downloadBtn];
        
        UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth-margin-btnWitdh*2, (bottomBarHeight-btnWitdh)/2, btnWitdh, btnWitdh)];
        [addBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
        [btn addSubview:addBtn];
        
        UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth-margin-btnWitdh, (bottomBarHeight-btnWitdh)/2, btnWitdh, btnWitdh)];
        [deleteBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
        [btn addSubview:deleteBtn];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, bottomBarHeight-0.05, screenWidth, 0.05)];
        line.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:line];
        
        [self addTableViewWithFrame:CGRectMake(0, bottomBarHeight, screenWidth, bottomHeight-bottomBarHeight*2)];
        
        
        UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, bottomHeight-bottomBarHeight+0.1, screenWidth, 0.1)];
        line2.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:line2];
        UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, bottomHeight-bottomBarHeight, screenWidth, bottomBarHeight)];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [closeBtn setBackgroundColor:[UIColor whiteColor]];
        closeBtn.tag = 102;
        [closeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:closeBtn];
    }
}

-(void)addTableViewWithFrame:(CGRect)frame{
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [tableView registerClass:[MusicQueueCell class] forCellReuseIdentifier:@"cell"];

    
    [self setTableFooterView:tableView];
    [self.contentView addSubview:tableView];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIButton *btn = [self.contentView viewWithTag:101];
        NSInteger mode = [[NSUserDefaults standardUserDefaults]integerForKey:@"mode"];
        [self updatePlayModeWithMode:mode andBtn:btn];
        //刷新完成
        self.curSongId = ((TingSong *)([self.dataArray objectAtIndex:self.curIndex])).songId;
        NSLog(@"self.curSongId=%ld,self.curIndex=%d,self.dataArray.count=%ld",[self.curSongId integerValue],self.curIndex,self.dataArray.count);
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self.curIndex inSection:0];
        [tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    });
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicQueueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell = [[MusicQueueCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    TingSong *tingSong =self.dataArray[indexPath.row];
    [cell setData:tingSong withSongId:self.curSongId withState:self.curState];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TingSong *tingSong = [self.dataArray objectAtIndex:indexPath.row];
    if (tingSong.auditionList.count==0) {
        return;
    }
//    [self.delegate setTingSongQueue:self.dataArray];
    
    self.curState =[self.delegate initPlay:tingSong.songId index:(int)indexPath.row isLocal:[[NSUserDefaults standardUserDefaults]boolForKey:@"isLocal"]];
    self.curSongId = tingSong.songId;
    [tableView reloadData];
}

//去掉多余横线
- (void)setTableFooterView:(UITableView *)tb {
    if (!tb) {
        return;
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [tb setTableFooterView:view];
}

-(void)btnClick:(UIButton *)btn{
    NSInteger tag = btn.tag;
    switch (tag) {
        case 101:{
            NSLog(@"切换模式");
            NSInteger mode = [[NSUserDefaults standardUserDefaults]integerForKey:@"mode"];
            int curMode =(mode+1)%4;
            [self updatePlayModeWithMode:curMode andBtn:btn];
            break;
        }
            
        case 102:
            [self disMissView];
            break;
            
        default:
            break;
    }
}
-(void)updatePlayModeWithMode:(NSInteger) curMode andBtn:(UIButton *)btn{
    UILabel *label = [btn viewWithTag:201];
    UIImageView *modeImageView = [btn viewWithTag:301];
    switch (curMode) {
        case 0:
            modeImageView.image = [UIImage imageNamed:@"icon_mode_all_repeat"];
            label.text =[NSString stringWithFormat:@"列表循环(%ld首)",self.dataArray.count];
            break;
        case 1:
            modeImageView.image = [UIImage imageNamed:@"icon_mode_order"];
            label.text =[NSString stringWithFormat:@"顺序播放(%ld首)",self.dataArray.count];
            break;
        case 2:
            modeImageView.image = [UIImage imageNamed:@"icon_mode_repete_one"];
            label.text =[NSString stringWithFormat:@"单曲循环(%ld首)",self.dataArray.count];
            break;
        case 3:
            modeImageView.image = [UIImage imageNamed:@"icon_mode_shuffle"];
            label.text =[NSString stringWithFormat:@"随机播放(%ld首)",self.dataArray.count];
            break;
            
        default:
            break;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:curMode forKey:@"mode"];
    [userDefault synchronize];
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view
{
    if (!view){
        return;
    }
    
    [view addSubview:self];
    [view addSubview:self.contentView];
    
    [self.contentView setFrame:CGRectMake(0, screenHeight, screenWidth, bottomHeight)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha =1;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self.contentView setFrame:CGRectMake(0, screenHeight - bottomHeight, screenWidth, bottomHeight)];
        
    } completion:nil];
}

-(void)disMissView{
    [self.contentView setFrame:CGRectMake(0, screenHeight - bottomHeight, screenWidth, bottomHeight)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [self.contentView setFrame:CGRectMake(0, screenHeight, screenWidth, bottomHeight)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [self.contentView removeFromSuperview];
                         
                     }];
}

@end
