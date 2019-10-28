//
//  SMWKWebViewController.m
//  OC-JS-WKWebView
//
//  Created by KT-yzx on 2019/10/14.
//  Copyright © 2019 OC-JS-WKWebView. All rights reserved.
//

#import "SMWKWebViewController.h"
#import "SMNavigationController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import "CMLoginViewController.h"

@interface SMWKWebViewController ()<WKScriptMessageHandler, WKNavigationDelegate>{
    
    BOOL deviceTokenBool;
    UIButton *leftButton;
    UIButton *rightButton;
}

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView * progressView;

@end

@implementation SMWKWebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"pushViewController"];//注入h5调取oc的方法
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"getDeviceToken"];//注入h5调取oc的方法
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"rightBarButtonItemWithTitle"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"loginViewControllerFunc"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"popViewControllerAnimatedFunc"];
      [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"popToRootViewControllerAnimatedFunc"];

    if (self.showType == pushViewControllerType || self.showType == jsBackType) {
        SMNavigationController * navigation = (SMNavigationController *)[AppDelegate getWindow].rootViewController;
        if (navigation.viewControllers.count == 1 ) {
            self->leftButton.hidden = YES;
        }else{
            self->leftButton.hidden = NO;
        }
    }

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"pushViewController"];//取消h5调取oc的方法
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"getDeviceToken"];//取消h5调取oc的方法
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"rightBarButtonItemWithTitle"];//取消h5调取oc的方法
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"loginViewControllerFunc"];//取消h5调取oc的方法
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"popViewControllerAnimatedFunc"];//取消h5调取oc的方法
       [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"popToRootViewControllerAnimatedFunc"];//取消h5调取oc的方法
}

- (void)backButtonFunc:(NSString *)sender{
           
       [self.wkWebView evaluateJavaScript:@"pressBackButton()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
           //TODO
           NSLog(@"%@ %@",response,error);
       }];
    
}

- (void)pressBackButton:(UIButton *)sender{
    
    if (self.showType == defaultType) {
        
        if ([self.wkWebView canGoBack]) {
            [self.wkWebView goBack];
        }else{
            self->leftButton.hidden = YES;
            
        }
        
    }
    
    if (self.showType == presentViewControllerType) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.showType == pushViewControllerType) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (self.showType == jsBackType) {
        [self backButtonFunc:@""];
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.wkWebView.frame = CGRectMake(0, 0, self.allView.frame.size.width, self.allView.frame.size.height);
   
    CGFloat progressBarHeight = 3.f;
    CGRect barFrame = CGRectMake(0, 0, self.allView.frame.size.width, progressBarHeight);
    self.progressView.frame = barFrame;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self leftBarButtonItemFunc];
    self->leftButton.hidden = YES;
    if (self.showType == presentViewControllerType) {
    self->leftButton.hidden = NO;
    }
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.allView.bounds configuration:config];
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    [self.allView addSubview:self.wkWebView];
    
    if (!self.urlString || self.urlString.length == 0) {
        
        [self alertFunc];
        
    }
    else if ([self.urlString isEqualToString:@"https://www.xxxx.com"]) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"html"];
        
        
        NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
        [self.wkWebView loadHTMLString:htmlCont baseURL:baseURL];
        
    }
    else{
        
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
        
    }
    
    CGFloat progressBarHeight = 3.f;
    CGRect barFrame = CGRectMake(0, 0, self.view.frame.size.width, progressBarHeight);
    self.progressView = [[UIProgressView alloc]initWithFrame:barFrame];
    self.progressView.progressTintColor = [UIColor colorWithRed:0/255.0 green:159/255.0 blue:255/255.0 alpha:1];
    self.progressView.trackTintColor = [UIColor clearColor];
    [self.allView addSubview:self.progressView];
    
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView addObserver:self
                     forKeyPath:@"title"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    
}

- (void)leftBarButtonItemFunc{
    
    
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 2, 40, 26);
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton addTarget:self action:@selector(pressBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"arrow_left_back"] forState:UIControlStateNormal];
    UIBarButtonItem *barIten = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = barIten;
    
}

- (void)rightBarButtonItemWithTitle:(NSString *)title{
    
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 2, 40, 26);
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addTarget:self action:@selector(pressRightButton:) forControlEvents:UIControlEventTouchUpInside];
    if (title) {
        [rightButton setTitle:title forState:UIControlStateNormal];
    }
//    [rightButton setImage:[UIImage imageNamed:@"arrow_left_back"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *barIten = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = barIten;
    
}

- (void)pressRightButton:(UIButton *)sender{
    
    [self.wkWebView evaluateJavaScript:@"pressRightButton()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
               //TODO
               NSLog(@"%@ %@",response,error);
           }];
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
    
    
    if (self.showType == defaultType) {
        if ([self.wkWebView canGoBack]) {
            self->leftButton.hidden = NO;
        }else{
            self->leftButton.hidden = YES;
        }
        
    }
    
    if (deviceTokenBool) {
        NSString * deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        
        
        NSString *jsonString = nil;
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"deviceToken":deviceToken} options:NSJSONWritingPrettyPrinted error:&parseError];
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        
        
        
        NSString * funcStr = [NSString stringWithFormat:@"getDeviceTokenFunc('%@')", deviceToken];
        [self.wkWebView evaluateJavaScript:funcStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            //TODO
            NSLog(@"%@ %@",response,error);
        }];
        deviceTokenBool = NO;
    }
    
    
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
    
    
    if (self.showType == pushViewControllerType || self.showType == jsBackType) {
        if ([strRequest isEqualToString:self.urlString]) {
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strRequest]]) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SMWKWebViewController * webViewController = [storyboard instantiateViewControllerWithIdentifier:@"SMWKWebViewController"];
            webViewController.urlString = strRequest;
            webViewController.showType = self.showType;
            [self.navigationController pushViewController:webViewController animated:YES];
            decisionHandler(WKNavigationActionPolicyCancel);
            
            return;
        }
    }
    if (self.showType == presentViewControllerType) {
        if ([strRequest isEqualToString:self.urlString]) {
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strRequest]]) {


            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                       SMWKWebViewController * webViewController = [storyboard instantiateViewControllerWithIdentifier:@"SMWKWebViewController"];
            webViewController.urlString = strRequest;
            webViewController.showType = self.showType;
            SMNavigationController * navition = [[SMNavigationController alloc] initWithRootViewController:webViewController];
            navition.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self presentViewController:navition animated:YES completion:nil];
            
            decisionHandler(WKNavigationActionPolicyCancel);
            
            return;
        }
    }

    
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    
   
    
    //不允许跳转
    //    decisionHandler(WKNavigationActionPolicyCancel);
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
    
    if ([message.name isEqualToString:@"pushViewController"]) {//js调取OC的函数
        
        //        NSArray *array = message.body;
        NSString * urlString = message.body;
        [self pushViewController:urlString];
        
    }
    if ([message.name isEqualToString:@"getDeviceToken"]) {
        NSString * sender = message.body;
        [self getDeviceToken:sender];
    }
    if ([message.name isEqualToString:@"rightBarButtonItemWithTitle"]) {
        NSString * sender = message.body;
        [self rightBarButtonItemWithTitle:sender];
    }
    if ([message.name isEqualToString:@"loginViewControllerFunc"]) {
        NSString * sender = message.body;
        [self loginViewControllerFunc:sender];
    }
    if ([message.name isEqualToString:@"popViewControllerAnimatedFunc"]) {
           NSString * sender = message.body;
           [self popViewControllerAnimatedFunc:sender];
       }
       if ([message.name isEqualToString:@"popToRootViewControllerAnimatedFunc"]) {
           NSString * sender = message.body;
           [self popToRootViewControllerAnimatedFunc:sender];
       }
    
}

#pragma mark - js的调用



//oc函数具体的实现
- (void)pushViewController:(NSString *)url{
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
               SMWKWebViewController * webViewController = [storyboard instantiateViewControllerWithIdentifier:@"SMWKWebViewController"];
    webViewController.urlString = url;

    webViewController.showType = self.showType;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)popViewController:(NSString *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)presentViewController:(NSString *)url{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
               SMWKWebViewController * webViewController = [storyboard instantiateViewControllerWithIdentifier:@"SMWKWebViewController"];
    webViewController.urlString = url;
    SMNavigationController * navition = [[SMNavigationController alloc] initWithRootViewController:webViewController];
    navition.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navition animated:YES completion:nil];
    
}

- (void)dismissViewController:(NSString *)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getDeviceToken:(NSString *)sender{
    
    deviceTokenBool = YES;
    
}

- (void)loginViewControllerFunc:(NSString *)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CMLogin" bundle:nil];
    CMLoginViewController * loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"CMLoginViewController"];
    [self.navigationController pushViewController:loginViewController animated:YES];
    
}

- (void)popViewControllerAnimatedFunc:(NSString *)type{
    
    BOOL typeBool = YES;
    if (type && [type isEqualToString:@"0"]) {
        typeBool = NO;
    }
    [self.navigationController popViewControllerAnimated:typeBool];
}

- (void)popToRootViewControllerAnimatedFunc:(NSString *)type{
    BOOL typeBool = YES;
       if (type && [type isEqualToString:@"0"]) {
           typeBool = NO;
       }
       [self.navigationController popToRootViewControllerAnimated:typeBool];
}

#pragma mark - 弹窗
- (void)alertFunc{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入网址" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"默认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField* userNameTextField = alertController.textFields.firstObject;
        self.urlString = userNameTextField.text;
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
        self.showType = defaultType;
        if ([self.wkWebView canGoBack]) {
            self->leftButton.hidden = NO;
        }else{
            self->leftButton.hidden = YES;
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"present" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField* userNameTextField = alertController.textFields.firstObject;
        self.urlString = userNameTextField.text;
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
        self.showType = presentViewControllerType;
        self->leftButton.hidden = YES;
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"push" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField* userNameTextField = alertController.textFields.firstObject;
        
        NSLog(@"网址：%@",userNameTextField.text);
        
        if (userNameTextField.text.length == 0) {
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSURL *baseURL = [NSURL fileURLWithPath:path];
            NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"html"];
            
            
            NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
            [self.wkWebView loadHTMLString:htmlCont baseURL:baseURL];
        }else{
            self.urlString = userNameTextField.text;
            [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
        }
        self.showType = pushViewControllerType;
        SMNavigationController * navigation = (SMNavigationController *)[AppDelegate getWindow].rootViewController;
        if (navigation.viewControllers.count == 1 ) {
            self->leftButton.hidden = YES;
        }else{
            self->leftButton.hidden = NO;
        }
        
        
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"js" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//           UITextField* userNameTextField = alertController.textFields.firstObject;
           NSString *path = [[NSBundle mainBundle] bundlePath];
           NSURL *baseURL = [NSURL fileURLWithPath:path];
           NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"html"];
           
           
           NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                          encoding:NSUTF8StringEncoding
                                                             error:nil];
           [self.wkWebView loadHTMLString:htmlCont baseURL:baseURL];
           self.showType = jsBackType;
        
        SMNavigationController * navigation = (SMNavigationController *)[AppDelegate getWindow].rootViewController;

           if (navigation.viewControllers.count == 1 ) {
               self->leftButton.hidden = YES;
           }else{
               self->leftButton.hidden = NO;
           }
       }]];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
        
        textField.placeholder=@"请输入网址";
        
        
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}


@end
