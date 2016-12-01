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
#define screenWidth  [[UIScreen mainScreen]bounds].size.width
#define screenHeight  ([[UIScreen mainScreen]bounds].size.height)
#define statusBarHeight 15
#define topContentHeight 50
#define navigationViewHeight 40
#define bottomHeight 60
@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addTopContent];
    
    [self addNavigatonView];
    [self addCollectionView];
}

-(void)addTopContent{
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, statusBarHeight+topContentHeight)];
    bgImageView.tag = 201;
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
    line.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line];
    
    UILabel *indcaitor = [[UILabel alloc]initWithFrame:CGRectMake(0, baseH+navigationViewHeight-1, width, 1.4)];
    indcaitor.backgroundColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0];
    [self.view addSubview:indcaitor];
}
-(void)addCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
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
