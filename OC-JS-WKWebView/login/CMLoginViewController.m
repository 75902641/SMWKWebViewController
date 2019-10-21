//
//  CMLoginViewController.m
//  OC-JS-WKWebView
//
//  Created by shuimiaomiao on 2019/10/21.
//  Copyright © 2019 OC-JS-WKWebView. All rights reserved.
//

#import "CMLoginViewController.h"
#import "RegexKitLite.h"

@interface CMLoginViewController ()

@end

@implementation CMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.phoneNumberTextField addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventEditingChanged];
    [self leftBarButtonItemFunc];
}

- (void)pressBackButton:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftBarButtonItemFunc{
    
    
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 2, 40, 26);
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton addTarget:self action:@selector(pressBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"arrow_left_back"] forState:UIControlStateNormal];
    UIBarButtonItem *barIten = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = barIten;
    
}

- (void)changeBtn:(UITextField *) TextField{//当电话号码是手动输入长度超过11则执行
    
    if(self.phoneNumberTextField.text.length >= 11)
    {
       
        self.phoneNumberTextField.text =  [self.phoneNumberTextField.text substringWithRange:NSMakeRange(0,11)];
    }
}


- (IBAction)pressVerificationButton:(UIButton *)sender{
    
}


//判断手机号
- (BOOL)isPhoneNumberJudgment
{
    if (self.phoneNumberTextField.text && ![self.phoneNumberTextField.text isEqualToString:@""]) {
        NSString *regex = @"^(10|11|12|13|14|15|16|17|18|19){1}[0-9]{9}$";
        return [self.phoneNumberTextField.text isMatchedByRegex:regex];
    }
    return NO;
}

- (IBAction)pressLoginButton:(UIButton *)sender{
    
    if (![self isPhoneNumberJudgment])
    {

        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请输入正确的手机号" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
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
