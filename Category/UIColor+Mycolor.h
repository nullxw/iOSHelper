//
//  UIColor+Mycolor.h
//  text
//
//  Created by imht-ios on 14-5-26.
//  Copyright (c) 2014年 ymht. All rights reserved.
//

/*
 
 使用说明：
        系统的颜色无法满足你，那么把颜色写到这个类里把
        修改navigationItem 的颜色时，在IOS7中， 会自动对颜色进行改变alph， 请注意，非该类问题
 */


#import <UIKit/UIKit.h>

@interface UIColor (Mycolor)

+ (UIColor *)selectDarkGreen;
+ (UIColor *)darkGreen;
+ (UIColor *)myGray;
+ (UIColor *)naviBarColor;

/**
 *  颜色
 *
 *  @param rgbValue 16 进制数字
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithHexRGB:(unsigned long)rgbValue;

/**
 *  navigationitem 的背景颜色
 */
+ (UIColor *)naviItemBackColor;

+ (UIColor *)myRandomColor;

+ (UIColor *)ytColorWithRed:(CGFloat)red
                      green:(CGFloat)green
                       blue:(CGFloat)blue
                      alpha:(CGFloat)alpha;



@end
