//
//  GHLayoutHelper.h
//  HealthCareO2OForDemander
//
//  Created by GongHe on 15/9/23.
//  Copyright (c) 2015年 vodone.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GHLayoutHelper : NSObject

+(CGSize)getSizeByText:(NSString *)text font:(UIFont *)textFont constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
+(CGSize)getSizeByText:(NSString *)text font:(UIFont *)textFont constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode lineSpacing:(CGFloat)line;
@end
