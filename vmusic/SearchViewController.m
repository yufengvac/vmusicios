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

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTopContent];
    [self.view setBackgroundColor:[UIColor whiteColor]];
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
    
    UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(topContentHeight,statusBarHeight+(topContentHeight-25)/2, screenWidth- topContentHeight*2, 25)];
    bg.backgroundColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.89 alpha:1.0];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bg.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(2.5, 2.5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = bg.bounds;
    maskLayer.path = maskPath.CGPath;
    bg.layer.mask = maskLayer;
    [self.view addSubview:bg];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(topContentHeight+10,statusBarHeight+(topContentHeight-25)/2, screenWidth- topContentHeight*2-10, 25)];
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
