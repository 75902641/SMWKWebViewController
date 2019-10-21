//
//  CMLoginViewController.h
//  OC-JS-WKWebView
//
//  Created by houchenguang on 2019/10/21.
//  Copyright © 2019 OC-JS-WKWebView. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField * phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField * passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton * verificationButton;

- (IBAction)pressVerificationButton:(UIButton *)sender;
- (IBAction)pressLoginButton:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
