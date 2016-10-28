//
//  ViewController.m
//  XTWebView
//
//  Created by TuTu on 16/10/28.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "ViewController.h"
#import "XTWebView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    XTWebView *webView = [[XTWebView alloc] initWithFrame:self.view.frame] ;
    [self.view addSubview:webView] ;
    
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]] ;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
