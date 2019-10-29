//
//  GHLayoutHelper.m
//  HealthCareO2OForDemander
//
//  Created by GongHe on 15/9/23.
//  Copyright (c) 2015年 vodone.com. All rights reserved.
//

#import "GHLayoutHelper.h"

@implementation GHLayoutHelper

+(CGSize)getSizeByText:(NSString *)text font:(UIFont *)textFont constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    
    

        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:textFont, NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil];
        CGRect rect = [text boundingRectWithSize:size options:options attributes:dic context:nil];
        
        return rect.size;
    
}

+(CGSize)getSizeByText:(NSString *)text font:(UIFont *)textFont constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode lineSpacing:(CGFloat)line
{
    
    
    
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        [paragraphStyle setLineSpacing:line];

        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:textFont, NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil];
        CGRect rect = [text boundingRectWithSize:size options:options attributes:dic context:nil];
        
        return rect.size;

}

@end
