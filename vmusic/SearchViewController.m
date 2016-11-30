//
//  SearchViewController.m
//  vmusic
//
//  Created by feng yu on 16/11/30.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 400, 300)];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:back];
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
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
