//
//  ViewController.m
//  Interaction
//
//  Created by KT-yzx on 2019/9/20.
//  Copyright © 2019 QuickTo. All rights reserved.
//

#import "ViewController.h"
#import "SMWKWebViewController.h"


@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton * wkWebButton = [UIButton buttonWithType:UIButtonTypeCustom];
       wkWebButton.frame = CGRectMake(100, 100, 100, 100);
       [wkWebButton addTarget:self action:@selector(pressWkwebViewButton:) forControlEvents:UIControlEventTouchUpInside];
    [wkWebButton setTitle:@"加载h5" forState:UIControlStateNormal];
    [wkWebButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:wkWebButton];
}

- (void)pressWkwebViewButton:(UIButton *)sender{
    
    SMWKWebViewController * webViewController = [[SMWKWebViewController alloc] init];
    [self.navigationController pushViewController:webViewController animated:YES];
    
}





@end
