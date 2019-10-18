//
//  SMWKWebViewController.h
//  OC-JS-WKWebView
//
//  Created by KT-yzx on 2019/10/14.
//  Copyright © 2019 OC-JS-WKWebView. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {

    defaultType,
    pushViewControllerType,
    presentViewControllerType,
    
}ControllerShowType;

NS_ASSUME_NONNULL_BEGIN

@interface SMWKWebViewController : UIViewController
@property (nonatomic, copy)NSString * urlString;
@property (nonatomic, assign) ControllerShowType showType;
@property (weak, nonatomic)IBOutlet UIView * allView;
@end

NS_ASSUME_NONNULL_END
