//
//  VKVVideoViewController.m
//  VK videos
//
//  Created by 1 on 18.03.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "VKVVideoViewController.h"
#import <WebKit/WebKit.h>

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]


@interface VKVVideoViewController ()<WKNavigationDelegate>
@property (strong,nonatomic) WKWebView *webView;

@end

@implementation VKVVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:Rgb2UIColor(80, 114, 153)];
    
    WKAudiovisualMediaTypes avmt=WKAudiovisualMediaTypeVideo;
    WKWebViewConfiguration *config=[[WKWebViewConfiguration alloc]init];
    config.mediaTypesRequiringUserActionForPlayback=avmt;
    
    _webView=[[WKWebView alloc]initWithFrame: self.view.bounds configuration:config];
    _webView.navigationDelegate=self;
    [self.view addSubview:_webView];
    
    NSURLRequest *nsurlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:_videoURL]];
    [_webView loadRequest:nsurlRequest];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;


    
}

#pragma - WKNavigationDelegate
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"webView didCommitNavigation");
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"webView didStartProvisionalNavigation");
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"webView didFinishNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


-(void)viewWillDisappear:(BOOL)animated{
    [_webView stopLoading];
    NSLog(@"stop loading");
}

@end
