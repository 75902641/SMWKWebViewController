//
//  SMWKWebViewController.m
//  OC-JS-WKWebView
//
//  Created by KT-yzx on 2019/10/14.
//  Copyright © 2019 OC-JS-WKWebView. All rights reserved.
//

#import "SMWKWebViewController.h"
#import <WebKit/WebKit.h>

@interface SMWKWebViewController ()<WKScriptMessageHandler, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView * progressView;

@end

@implementation SMWKWebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"oh_initWithFrame"];//注入h5调取oc的方法
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"oh_initWithFrame"];//取消h5调取oc的方法
    
    
    
}

- (void)pressBackButton:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //返回按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 2, 40, 26);
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn addTarget:self action:@selector(pressBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"arrow_left_back"] forState:UIControlStateNormal];
    UIBarButtonItem *barIten = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.leftBarButtonItem = barIten;
    
    //加载本地的html文件
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
    [self.view addSubview:self.wkWebView];
    
    CGFloat progressBarHeight = 3.f;
    CGRect barFrame = CGRectMake(0, 0, self.view.frame.size.width, progressBarHeight);
    self.progressView = [[UIProgressView alloc]initWithFrame:barFrame];
    self.progressView.progressTintColor = [UIColor colorWithRed:0/255.0 green:159/255.0 blue:255/255.0 alpha:1];
    self.progressView.trackTintColor = [UIColor clearColor];
    [self.view addSubview:self.progressView];
    
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView addObserver:self
                     forKeyPath:@"title"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual:@"estimatedProgress"] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:YES];
        if (self.wkWebView.estimatedProgress  >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:YES];
            }];
        }
    }
    else if ([keyPath isEqualToString:@"title"]) {
        
        self.title = self.wkWebView.title;
        
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - navigationDelegate


//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"开始加载2");
}

//内容返回时调用，得到请求内容时调用(内容开始加载) -> view的过渡动画可在此方法中加载
- (void)webView:(WKWebView *)webView didCommitNavigation:( WKNavigation *)navigation
{
    NSLog(@"内容返回时调用，得到请求内容时4");
    
}

//页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:( WKNavigation *)navigation
{
    NSLog(@"页面加载完成时5");
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    NSString * funcStr = [NSString stringWithFormat:@"widthAndHeight(%f,%f)", width, height];
    [self.wkWebView evaluateJavaScript:funcStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //TODO
        NSLog(@"%@ %@",response,error);
    }];
    
}

//请求失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"error1:%@",error);
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"error2:%@",error);
}

//在请求发送之前，决定是否跳转 -> 该方法如果不实现，系统默认跳转。如果实现该方法，则需要设置允许跳转，不设置则报错。
//该方法执行在加载界面之前
//Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Completion handler passed to -[ViewController webView:decidePolicyForNavigationAction:decisionHandler:] was not called'
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    NSLog(@"url =========== %@", navigationAction.request.URL);
    
    NSString * strRequest = [NSString stringWithFormat:@"%@", navigationAction.request.URL];
    
    NSString *scheme = [navigationAction.request.URL scheme];
    
    //h5页面打电话 单独处理
    if ([scheme isEqualToString:@"tel"]) {
        
        
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", [navigationAction.request.URL resourceSpecifier]];
        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        //        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        //        });
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    
    if ([strRequest isEqualToString:self.urlString]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    SMWKWebViewController * webViewController = [[SMWKWebViewController alloc] init];
    webViewController.urlString = strRequest;
    [self.navigationController pushViewController:webViewController animated:YES];
    
    
    
    //允许跳转
    //    decisionHandler(WKNavigationActionPolicyAllow);
    
    //不允许跳转
    decisionHandler(WKNavigationActionPolicyCancel);
    NSLog(@"在请求发送之前，决定是否跳转 1");
}

//在收到响应后，决定是否跳转（同上）
//该方法执行在内容返回之前
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //    decisionHandler(WKNavigationResponsePolicyCancel);
    NSLog(@"在收到响应后，决定是否跳转。 3");
    
}

//接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"接收到服务器跳转请求之后调用");
}

-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    NSLog(@"webViewWebContentProcessDidTerminate");
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"message.name = %@",message.name);
    NSLog(@"message.body = %@",message.body);
    
    if ([message.name isEqualToString:@"oh_initWithFrame"]) {//js调取OC的函数
        
        NSArray *array = message.body;
        [self oh_initWithFrame:array];
        
    }
    
    
}

#pragma mark - UI控件的调用



//oc函数具体的实现
- (void)oh_initWithFrame:(NSArray *)model{
    
    
    
}


@end
