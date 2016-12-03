//
//  SearchViewController.m
//  vmusic
//
//  Created by feng yu on 16/11/30.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "SearchViewController.h"
#import "SCPresentTransition.h"
#import "AVFoundation/AVFoundation.h"
#import "SearchSongCell.h"
#import "TingSong.h"
#include "TingAudition.h"
#define screenWidth  [[UIScreen mainScreen]bounds].size.width
#define screenHeight  ([[UIScreen mainScreen]bounds].size.height)
#define statusBarHeight 15
#define topContentHeight 50
#define navigationViewHeight 40
#define bottomHeight 60
@interface SearchViewController ()
@property NSMutableDictionary *diction;
@property NSString *keyWord;
@property NSMutableArray *songDataArray;
@end

@implementation SearchViewController
BOOL hasAddView = NO;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addTopContent];
    
//    [self addNavigatonView];
//    [self addCollectionView];
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
    
    UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(topContentHeight,statusBarHeight+(topContentHeight-30)/2, screenWidth- topContentHeight*2, 30)];
    bg.backgroundColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bg.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(2.5, 2.5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = bg.bounds;
    maskLayer.path = maskPath.CGPath;
    bg.layer.mask = maskLayer;
    [self.view addSubview:bg];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(topContentHeight+10,statusBarHeight+(topContentHeight-30)/2, screenWidth- topContentHeight*2-10, 30)];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = @"搜索音乐、歌单、专辑、MV";
    textField.font = [UIFont systemFontOfSize:13];
    textField.textColor = [UIColor whiteColor];
    textField.delegate = self;
    textField.clearButtonMode = UITextBorderStyleNone;
    textField.returnKeyType = UIReturnKeySearch;
    textField.tintColor = [UIColor whiteColor];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置富文本对象的颜色
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    // 设置UITextField的占位文字
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索音乐、歌单、专辑、MV" attributes:attributes];

    [self.view addSubview:textField];
    
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth-topContentHeight, statusBarHeight, topContentHeight, topContentHeight)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.textColor = [UIColor whiteColor];
    cancel.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:cancel];
    
    
}


-(void)addLoadingTips{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((screenWidth-150)/2, (screenHeight-20)/3, 150, 20)];
    label.text = [NSString stringWithFormat:@"正在搜索%@",self.keyWord];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    NSString *url = [NSString stringWithFormat:@"http://search.dongting.com/song/search?size=20&page=%d&q=%@",1,self.keyWord];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"result=%@",result);
        if (data==nil) {
            label.text = @"无返回结果！";
            return ;
        }
        NSDictionary *jsonDirc = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        NSNumber *pageCount = [jsonDirc objectForKey:@"pageCount"];
        self.songDataArray = [[NSMutableArray alloc]init];
        NSMutableArray *tingSongArray =  [jsonDirc mutableArrayValueForKey:@"data"];
        if (tingSongArray.count>0) {
            for (int i=0; i<tingSongArray.count; i++) {
                NSDictionary *jsonDirc1 = [tingSongArray objectAtIndex:i];
                TingSong *tingSong = [[TingSong alloc]init];
                tingSong.songId = [jsonDirc1 objectForKey:@"songId"];
                tingSong.name = [jsonDirc1 objectForKey:@"name"];
                tingSong.alias = [jsonDirc1 objectForKey:@"alias"];
                tingSong.singerId = [jsonDirc1 objectForKey:@"singerId"];
                tingSong.singerName = [jsonDirc1 objectForKey:@"singerName"];
                tingSong.albumId  = [jsonDirc1 objectForKey:@"albumId"];
                tingSong.albumName = [jsonDirc1 objectForKey:@"albumName"];
                tingSong.favorites = [jsonDirc1 objectForKey:@"favorites"];
                tingSong.auditionList = [[NSMutableArray alloc]init];
                
                NSMutableArray *auditionArray = [jsonDirc1 mutableArrayValueForKey:@"auditionList"];
                
                if (auditionArray.count>0) {
                    for (int j=0; j<auditionArray.count; j++) {
                        TingAudition *auditon = [[TingAudition alloc]init];
                        NSDictionary *audionDic = [auditionArray objectAtIndex:j];
                        auditon.bitRate = [audionDic objectForKey:@"bitRate"];
                        auditon.duration = [audionDic objectForKey:@"duration"];
                        auditon.size = [audionDic objectForKey:@"size"];
                        auditon.suffix= [audionDic objectForKey:@"suffix"];
                        auditon.url = [audionDic objectForKey:@"url"];
                        auditon.typeDescription = [audionDic objectForKey:@"typeDescription"];
                        [tingSong.auditionList addObject:auditon];
                    }
                }
                
                [self.songDataArray addObject:tingSong];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [label removeFromSuperview];
                [self removeNavigationView];
                [self addNavigatonView];
                [self addCollectionView];
            });
        }else{
            label.text = @"无返回结果！";
        }
    }];
    [task resume];
}


-(void)addNavigatonView{
    NSInteger width = screenWidth/4;
    NSInteger baseH = statusBarHeight + topContentHeight;
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0,baseH , width, navigationViewHeight)];
    [btn1 setTitle:@"单曲" forState:UIControlStateNormal];
    [btn1 setTitleColor: [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0] forState: UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    btn1.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn1.tag = 101;
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(width, baseH, width, navigationViewHeight)];
    [btn2 setTitle:@"专辑" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:13];
    btn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn2.tag = 102;
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(width*2, baseH, width, navigationViewHeight)];
    [btn3 setTitle:@"歌单" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:13];
    btn3.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn3.tag = 103;
    [self.view addSubview:btn3];
    
    
    UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(width*3, baseH, width, navigationViewHeight)];
    [btn4 setTitle:@"MV" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:13];
    btn4.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn4.tag = 104;
    [self.view addSubview:btn4];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, baseH+navigationViewHeight, screenWidth, 0.1)];
    line.tag = 201;
    line.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line];
    
    UILabel *indcaitor = [[UILabel alloc]initWithFrame:CGRectMake(0, baseH+navigationViewHeight-1, width, 2)];
    indcaitor.tag = 202;
    indcaitor.backgroundColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0];
    [self.view addSubview:indcaitor];
}

-(void)removeNavigationView{
    UIButton *btn1 = [self.view viewWithTag:101];
    UIButton *btn2 = [self.view viewWithTag:102];
    UIButton *btn3 = [self.view viewWithTag:103];
    UIButton *btn4 = [self.view viewWithTag:104];
    
    UILabel *label1 = [self.view viewWithTag:201];
    UILabel *label2 = [self.view viewWithTag:202];
    
    UIScrollView *scrollView = [self.view viewWithTag:301];
    if (btn1!=nil) {
        [btn1 removeFromSuperview];
    }
    if (btn2!=nil) {
        [btn2 removeFromSuperview];
    }
    if (btn3!=nil) {
        [btn3 removeFromSuperview];
    }
    if (btn4!=nil) {
        [btn4 removeFromSuperview];
    }
    if (label1!=nil) {
        [label1 removeFromSuperview];
    }
    if (label2!=nil) {
        [label2 removeFromSuperview];
    }
    if (scrollView!=nil) {
        [scrollView removeFromSuperview];
    }
}
//-(void)addCollectionView{
//    CGFloat y = statusBarHeight+topContentHeight+navigationViewHeight+0.1;
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    
//    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, y , screenWidth, screenHeight - y -bottomHeight) collectionViewLayout:flowLayout];
//    [collectionView registerClass:[SearchSongCell class] forCellWithReuseIdentifier:@"cellId"];
//    collectionView.pagingEnabled = YES;
//    collectionView.scrollEnabled = YES;
//    collectionView.dataSource = self;
//    collectionView.backgroundColor = [UIColor whiteColor];
//    collectionView.showsHorizontalScrollIndicator = NO;
//    [self.view addSubview:collectionView];
//}

-(void)addCollectionView{
    CGFloat y = statusBarHeight+topContentHeight+navigationViewHeight+0.1;
    self.diction = [[NSMutableDictionary alloc]init];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, y , screenWidth, screenHeight - y -bottomHeight)];
    scrollView.contentSize = CGSizeMake(screenWidth*4, screenHeight - y -bottomHeight);
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.delegate = self;
    scrollView.tag = 301;
    [self.view addSubview:scrollView];
    
    UITableView *songTableView = [self.diction objectForKey:@"one"];
    if (songTableView!=nil) {
        [songTableView removeFromSuperview];
    }
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:scrollView.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = YES;
    tableView.tag = 401;
    tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    tableView.contentSize = CGSizeMake(scrollView.bounds.size.width ,scrollView.bounds.size.height);
    [tableView registerClass:[SearchSongCell class] forCellReuseIdentifier:@"cellId"];
    [self.diction setObject:tableView forKey:@"one"];
    [scrollView addSubview:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    TingSong *tingSong = [self.songDataArray objectAtIndex:indexPath.row];
    if([tingSong.alias isKindOfClass:[NSNull class]]||tingSong.alias==nil||tingSong.alias.length==0){
        return 60;
    }else{
        return 80;
    }
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.songDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchSongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell==nil) {
        cell = [[SearchSongCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    TingSong *tingSong = self.songDataArray[indexPath.row];
    [cell setTingSong:tingSong];
    return cell;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn");
    if (textField.text==nil) {
        
    }else{
        [textField resignFirstResponder];
        self.keyWord = textField.text;
        [self addLoadingTips];
    }
    return YES;
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndScrollingAnimation -%.2f",scrollView.contentOffset.x);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.x == 0) {
        NSLog(@"第一页");
        UIView *uiview = [self.diction objectForKey:@"one"];
        if (uiview==nil) {
             NSLog(@"第一页为nil,去加载一个");
            UITableView *tableView = [[UITableView alloc]initWithFrame:scrollView.bounds];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.scrollEnabled = YES;
            tableView.contentSize = CGSizeMake(scrollView.bounds.size.width ,scrollView.bounds.size.height);
            [self.diction setObject:tableView forKey:@"one"];
            [scrollView addSubview:tableView];
        }
       
    }else if (scrollView.contentOffset.x == screenWidth){
        NSLog(@"第二页");
    }else if (scrollView.contentOffset.x == screenWidth*2){
        NSLog(@"第三页");
    }else if (scrollView.contentOffset.x == screenWidth*3){
        NSLog(@"第四页");
    }
}

-(void)btnClick:(UIButton *)btn{
    NSInteger tag = btn.tag;
    switch (tag) {
        case 101:
            
            break;
        case 102:
            break;
        default:
            break;
    }
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
