//
//  UIColor+Mycolor.m
//  text
//
//  Created by imht-ios on 14-5-26.
//  Copyright (c) 2014年 ymht. All rights reserved.
//

#import "UIColor+Mycolor.h"

@implementation UIColor (Mycolor)

+ (UIColor *)selectDarkGreen
{
    UIColor *color = [UIColor colorWithRed:117 / 255.0f green:210 / 255.0f blue:77 / 255.0f alpha:1];
    return color;
}

+ (UIColor *)darkGreen
{
    UIColor *color = [UIColor colorWithRed:57 / 255.0f green:177 / 255.0f blue:2 / 255.0f alpha:1];
    return color;
}

+ (UIColor *)myGray
{
    UIColor *color = [UIColor colorWithRed:238 / 255.0f green:243 / 255.0f blue:249 / 255.0f alpha:1];
    return color;
}

+ (UIColor *)naviBarColor{
    
    UIColor *color = [UIColor ytColorWithRed:28 green:201 blue:194 alpha:1];
    return color;
}


+ (UIColor *)myRandomColor
{
    NSUInteger rNum = random() % 256;
    NSUInteger gNum = random() % 256;
    NSUInteger bNum = random() % 256 ;
    
    UIColor *color = [UIColor colorWithRed:rNum / 255.0f green:gNum / 255.0f blue:bNum / 255.0f alpha:1];
    
    return color;
}

+ (UIColor *)colorWithHexRGB:(unsigned long)rgbValue
{
    
    
   UIColor *color = [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
    
    return color;
}



+ (UIColor *)naviItemBackColor
{
    UIColor *color = [UIColor colorWithRed:249 / 255.0f green:249 / 255.0f blue:249 / 255.0f alpha:1];
    return color;
}

+ (UIColor *)ytColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    UIColor *color = [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha];
    return color;
}




@end
