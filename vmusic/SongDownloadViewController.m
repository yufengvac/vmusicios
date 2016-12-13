//
//  SongDownloadViewController.m
//  vmusic
//
//  Created by feng yu on 16/12/13.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "SongDownloadViewController.h"
#import "SCPresentTransition.h"
#import "DBHelper.h"
#import "SearchSongCell.h"

#define screenWidth  [[UIScreen mainScreen]bounds].size.width
#define screenHeight  ([[UIScreen mainScreen]bounds].size.height)
#define statusBarHeight 15
#define topContentHeight 50

@interface SongDownloadViewController ()
@property(strong,nonatomic) NSArray *data;
@end

@implementation SongDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTopContent];
    [self addTableView];
}

-(void)addTopContent{
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, statusBarHeight+topContentHeight)];
    bgImageView.tag = 501;
    [bgImageView setBackgroundColor:[UIColor colorWithRed:0.33-0.0627 green:0.64-0.0627 blue:0.89-0.0627 alpha:1.0]];
    [self.view addSubview:bgImageView];
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, statusBarHeight, topContentHeight, topContentHeight)];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [back setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [self.view addSubview:back];
    
    
    NSArray *segmentedArr = [NSArray arrayWithObjects:@"已下载",@"正在下载", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArr];
    segmentedControl.frame = CGRectMake((screenWidth-150)/2, 10+statusBarHeight, 150, topContentHeight-20);
    segmentedControl.tintColor = [UIColor whiteColor];
    
     NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:13],NSForegroundColorAttributeName ,nil];
    [segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(segmentedChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
}
-(void)addTableView{
    self.data = [[DBHelper sharedDataBaseHelper]queryTable];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, statusBarHeight+topContentHeight, screenWidth, screenWidth-statusBarHeight-topContentHeight) style:UITableViewStylePlain];
    tableView.tag = 500;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    [tableView registerClass:[SearchSongCell class] forCellReuseIdentifier:@"cellId"];
    [self setTableFooterView:tableView];
    [self.view addSubview:tableView];
}
-(void)segmentedChange:(UISegmentedControl *)segment{
     UITableView *tableView = [self.view viewWithTag:500];
    if (segment.selectedSegmentIndex==0) {
        tableView.hidden = NO;
    }else if(segment.selectedSegmentIndex ==1){
         tableView.hidden = YES;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchSongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell = [[SearchSongCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    TingSong *tingSong = self.data[indexPath.row];
    [cell setTingSong:tingSong];

    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TingSong *tingSong = [self.data objectAtIndex:indexPath.row];
    if([tingSong.alias isKindOfClass:[NSNull class]]||tingSong.alias==nil||tingSong.alias.length==0){
        return 60;
    }else{
        return 80;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 50, 20)];
    label.text = @"随机播放歌曲";
    return label;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TingSong *tingSong = [self.data objectAtIndex:indexPath.row];
    if (tingSong.auditionList.count==0) {
        return;
    }
    [self.delegate setTingSongQueue:[NSMutableArray arrayWithArray:self.data]];
    
    [self.delegate initPlay:tingSong.songId index:(int)indexPath.row isLocal:YES];
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

-(void)back{
    [SCPresentTransition dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
