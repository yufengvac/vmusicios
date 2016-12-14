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
#import "SearchAlbumCell.h"
#import "TingSong.h"
#import "TingAudition.h"
#import "TingAlbum.h"
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
@property NSMutableArray *albumDataArray;
@property int curIndex;
@property int curAlbumIndex;
@property BOOL isLoading;
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
    UILabel *label;
    if ([self.view viewWithTag:203]==nil) {
        label = [[UILabel alloc]initWithFrame:CGRectMake((screenWidth-150)/2, (screenHeight-20)/3, 150, 20)];
        label.text = [NSString stringWithFormat:@"正在搜索%@",self.keyWord];
        label.tag = 203;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
    self.curIndex = 1;
    self.isLoading = YES;
    [self loadData:self.curIndex withLabel:label];
   
}

-(void)loadData:(int)index withLabel:(UILabel *)label{
    NSString *url = [NSString stringWithFormat:@"http://search.dongting.com/song/search?size=20&page=%d&q=%@",index,self.keyWord];
    NSString *urlEncode = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlEncode] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
//        NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"result=%@",[result substringToIndex:50]);
        if (data==nil) {
            if (label!=nil) {
                label.text = @"无返回结果！";
            }else{
                NSLog(@"无更多数据");
            }
            
            return ;
        }
        NSDictionary *jsonDirc = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        //        NSNumber *pageCount = [jsonDirc objectForKey:@"pageCount"];
        if (index==1) {
            self.songDataArray = [[NSMutableArray alloc]init];
        }
        NSMutableArray *tingSongArray =  [jsonDirc mutableArrayValueForKey:@"data"];
        if (tingSongArray.count>0) {
            NSLog(@"已经获取到单曲json");
            for (int i=0; i<tingSongArray.count; i++) {
                NSDictionary *jsonDirc1 = [tingSongArray objectAtIndex:i];
                TingSong *tingSong = [[TingSong alloc]init];
                tingSong.songId = [jsonDirc1 objectForKey:@"songId"];
                tingSong.name = [NSString stringWithFormat:@"%@",[jsonDirc1 objectForKey:@"name"]];
                tingSong.alias = [NSString stringWithFormat:@"%@",[jsonDirc1 objectForKey:@"alias"]];
                tingSong.singerId = [jsonDirc1 objectForKey:@"singerId"];
                tingSong.singerName = [NSString stringWithFormat:@"%@",[jsonDirc1 objectForKey:@"singerName"]];
                tingSong.albumId  = [jsonDirc1 objectForKey:@"albumId"];
                tingSong.albumName = [NSString stringWithFormat:@"%@",[jsonDirc1 objectForKey:@"albumName"]];
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
                self.isLoading = NO;
                if (index==1) {
                    [label removeFromSuperview];
                    [self removeNavigationView];
                    [self addNavigatonView];
                    [self addCollectionView];
                }else{
                    UITableView *tableView = [[self.view viewWithTag:301]viewWithTag:401];
                    [tableView reloadData];
                }
            });
        }else{
            if (label!=nil) {
                label.text = @"无返回结果！";
            }else{
                NSLog(@"----无更多数据");
            }
           
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
    btn1.titleLabel.font = [UIFont systemFontOfSize:15];
    btn1.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn1.tag = 101;
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(width, baseH, width, navigationViewHeight)];
    [btn2 setTitle:@"专辑" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    btn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn2.tag = 102;
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(width*2, baseH, width, navigationViewHeight)];
    [btn3 setTitle:@"歌单" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:15];
    btn3.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn3.tag = 103;
    [self.view addSubview:btn3];
    
    
    UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(width*3, baseH, width, navigationViewHeight)];
    [btn4 setTitle:@"MV" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:15];
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
    scrollView.showsHorizontalScrollIndicator = NO;
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
    if (tableView.tag==401) {
        TingSong *tingSong = [self.songDataArray objectAtIndex:indexPath.row];
        if([tingSong.alias isKindOfClass:[NSNull class]]||tingSong.alias==nil||tingSong.alias.length==0){
            return 60;
        }else{
            return 80;
        }
    }else if (tableView.tag == 402){
        return 70;
    }
    return 40;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==401) {
        TingSong *tingSong = [self.songDataArray objectAtIndex:indexPath.row];
        if (tingSong.auditionList.count==0) {
            return;
        }
        [self.delegate setTingSongQueue:self.songDataArray];
        
        [self.delegate initPlay:tingSong.songId index:(int)indexPath.row isLocal:NO];
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger tag = tableView.tag;
    if (tag ==401) {
        return self.songDataArray.count;
    }else if(tag == 402){
        return self.albumDataArray.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==401) {
        SearchSongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell = [[SearchSongCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        }
        TingSong *tingSong = self.songDataArray[indexPath.row];
        [cell setTingSong:tingSong];
        return cell;
    }else if(tableView.tag == 402){
        SearchAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumCellId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell = [[SearchAlbumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"albumCellId"];
        }
        TingAlbum *tingAlbum = self.albumDataArray[indexPath.row];
        [cell setTingAlbum:tingAlbum];
        return cell;
    }
    return nil;
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
        UIView *uiview = [self.diction objectForKey:@"one"];
        if (uiview==nil) {
            NSLog(@"第一页为nil,去加载一个");
            UITableView *tableView = [[UITableView alloc]initWithFrame:scrollView.bounds];
            tableView.tag = 401;
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
            [tableView registerClass:[SearchSongCell class] forCellReuseIdentifier:@"cellId"];
            [self.diction setObject:tableView forKey:@"one"];
            [scrollView addSubview:tableView];
        }
        [self selectIndex:1];
    }else if (scrollView.contentOffset.x == screenWidth){
        UIView *uiview = [self.diction objectForKey:@"two"];
        if (uiview==nil) {
            [self addAlbumTableView:scrollView];
        }
        [self selectIndex:2];
    }else if (scrollView.contentOffset.x == screenWidth*2){
        NSLog(@"第三页");
        [self selectIndex:3];
    }else if (scrollView.contentOffset.x == screenWidth*3){
        NSLog(@"第四页");
        [self selectIndex:4];
    }
}

-(void)selectIndex:(int)index{
    UIButton *btn1 = [self.view viewWithTag:101];
    UIButton *btn2 = [self.view viewWithTag:102];
    UIButton *btn3 = [self.view viewWithTag:103];
    UIButton *btn4 = [self.view viewWithTag:104];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    switch (index) {
        case 1:
            [btn1 setTitleColor: [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0] forState: UIControlStateNormal];
            break;
        case 2:
            [btn2 setTitleColor: [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0] forState: UIControlStateNormal];
            break;
        case 3:
            [btn3 setTitleColor: [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0] forState: UIControlStateNormal];
            break;
        case 4:
            [btn4 setTitleColor: [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0] forState: UIControlStateNormal];
            break;
        default:
            break;
    }
}

-(void)addAlbumTableView:(UIScrollView *)scrollView{
    NSLog(@"第二页为nil，去加载一个");
    UITableView *tableView = [[UITableView alloc]initWithFrame:scrollView.bounds style:UITableViewStylePlain];
    tableView.tag = 402;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    [tableView registerClass:[SearchAlbumCell class] forCellReuseIdentifier:@"albumCellId"];
    [self.diction setObject:tableView forKey:@"two"];
    tableView.hidden = YES;
    [scrollView addSubview:tableView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((screenWidth-150)/2+screenWidth, (screenHeight-20)/3, 150, 20)];
    label.text = [NSString stringWithFormat:@"正在搜索%@",self.keyWord];
    label.tag = 203;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:label];
    self.curAlbumIndex = 1;
    [self loadAlbumDataWithIndex:self.curAlbumIndex andTableView:tableView andTipLabel:label];
}

-(void)loadAlbumDataWithIndex:(int)index andTableView:(UITableView *)tableView andTipLabel:(UILabel *)label{
    dispatch_queue_t queue = dispatch_queue_create("loadAlbumData", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://search.dongting.com/album/search?size=20&page=%d&q=%@",index,self.keyWord]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
            
            if ([data isKindOfClass:[NSNull class]]||data==nil) {
                label.text = @"无返回结果！";
                return ;
            }
            NSLog(@"已经获取到专辑json");
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSMutableArray *jsonArray = [json mutableArrayValueForKey:@"data"];
            if (jsonArray!=nil&&jsonArray.count>0) {
                
                
                if (index==1) {
                    self.albumDataArray = [NSMutableArray array];
                }
                for (int i=0; i<jsonArray.count; i++) {
                    NSDictionary *json1 = [jsonArray objectAtIndex:i];
                    TingAlbum *album = [[TingAlbum alloc]init];
                    album.albumId = [json1 objectForKey:@"albumId"];
                    album.name = [json1 objectForKey:@"name"];
                    album.AlbumDescription = [json1 objectForKey:@"description"];
                    album.singerName = [json1 objectForKey:@"singerName"];
                    album.picUrl = [json1 objectForKey:@"picUrl"];
                    album.publishYear = [json1 objectForKey:@"publishYear"];
                    album.publishDate = [json1 objectForKey:@"publishDate"];
                    album.lang = [json1 objectForKey:@"lang"];
                    album.status = [json1 objectForKey:@"status"];
                    album.isExclusive = [json1 objectForKey:@"isExclusive"];
                    album.songs = [json1 mutableArrayValueForKey:@"songs"];
                    [self.albumDataArray addObject:album];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (label!=nil) {
                    label.hidden = YES;
                }
                self.isLoading = NO;
                tableView.hidden = NO;
                [tableView reloadData];
            });
            
        }];
        [task resume];
    });
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 401) {
        if (tableView.contentOffset.y+tableView.frame.size.height>tableView.contentSize.height) {
            if (!self.isLoading) {
                self.isLoading = YES;
                self.curIndex++;
                NSLog(@"加载单曲第%d页",self.curIndex);
                [self loadData:self.curIndex withLabel:nil];
            }
           
        }
    }else if (tableView.tag==402){
        if (tableView.contentOffset.y +tableView.frame.size.height>tableView.contentSize.height) {
            if (!self.isLoading) {
                self.isLoading = YES;
                self.curAlbumIndex++;
                NSLog(@"加载专辑的第%d页",self.curAlbumIndex);
                [self loadAlbumDataWithIndex:self.curAlbumIndex andTableView:tableView andTipLabel:nil];
            }
        }
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
