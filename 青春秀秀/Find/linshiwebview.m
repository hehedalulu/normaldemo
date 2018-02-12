//
//  linshiwebview.m
//  青春秀秀
//
//  Created by luluwang on 2018/1/14.
//  Copyright © 2018年 luluwang. All rights reserved.
//

#import "linshiwebview.h"

@interface linshiwebview ()

@end

@implementation linshiwebview

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webview = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    webview.scalesPageToFit = YES;
    [self.view addSubview:webview];
    NSURL* url = [NSURL URLWithString:@"https://www.nju.edu.cn/"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [webview loadRequest:request];//加载
    
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
