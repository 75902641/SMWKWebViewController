//
//  GHToastView.m
//  HealthCareO2OForDemander
//
//  Created by GongHe on 15/9/21.
//  Copyright (c) 2015年 vodone.com. All rights reserved.
//

#import "GHToastView.h"
#import "GHLayoutHelper.h"

@implementation GHToastView

UIView * _mainView;
float _keyboardHeight = 0;

+(void)showMessage:(NSString *)message
{
    if (_mainView) {
        [_mainView removeFromSuperview];
        _mainView = nil;
    }
    UIView * windowView = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    float keyboardHeight = 0;
    _keyboardHeight = 0;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    
    for (UIWindow *window in [windows reverseObjectEnumerator])//逆序效率更高，因为键盘总在上方
    {
        keyboardHeight = [self getKeyboardHeighInView:window];
    }
    
    CGSize size = [GHLayoutHelper getSizeByText:message font:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-40, 200) lineBreakMode:0];
    
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-size.width-40)/2.0, 64 + 15, size.width+40, 100)];
    _mainView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    [windowView addSubview:_mainView];
    [_mainView.layer setCornerRadius:10.0];
    _mainView.layer.masksToBounds = YES;
    _mainView.alpha = 0.4;
    
    
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width+40, _mainView.frame.size.height)];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.textAlignment = 1;
    textLabel.text = message;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.numberOfLines = 0;
    [_mainView addSubview:textLabel];
    
    CGSize textSize = [GHLayoutHelper getSizeByText:message font:textLabel.font constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-40, 200) lineBreakMode:NSLineBreakByWordWrapping];
    textLabel.frame = CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y, textLabel.frame.size.width, textSize.height + 28);
    
    if (keyboardHeight && (windowView.frame.size.height - keyboardHeight - 20 - textLabel.frame.size.height) < (windowView.frame.size.height - textLabel.frame.size.height)/2) {
        _mainView.frame = CGRectMake(_mainView.frame.origin.x, windowView.frame.size.height - keyboardHeight - 20 - textLabel.frame.size.height, _mainView.frame.size.width, textLabel.frame.size.height);
    }else{
        _mainView.frame = CGRectMake(_mainView.frame.origin.x, (windowView.frame.size.height - textLabel.frame.size.height)/2, _mainView.frame.size.width, textLabel.frame.size.height);
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    _mainView.alpha = 0.8;
    [UIView commitAnimations];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(suhidenMessage) object:nil];
    
    [self performSelector:@selector(suhidenMessage) withObject:nil afterDelay:1.5];
}

+(void)suhidenMessage{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    _mainView.alpha = 0;
    [UIView commitAnimations];
    _mainView = nil;
}

+ (float)getKeyboardHeighInView:(UIView *)view
{
    for (UIView *subView in [view subviews])
    {
        if (strstr(object_getClassName(subView), "UIKeyboard"))
        {
            _keyboardHeight = subView.frame.size.height;
            return subView.frame.size.height;
        }

        else
        {
            float height = [GHToastView getKeyboardHeighInView:subView];
            if (height)
            {
                return height;
            }
        }
    }
    return 0;
}


@end
