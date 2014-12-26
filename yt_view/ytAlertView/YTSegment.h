//
//  YTSegment.h
//  ImhtDoctor
//
//  Created by imht-ios on 14-6-23.
//  Copyright (c) 2014年 imht. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTSegment : UIView

//显示的数组
@property (strong, nonatomic) NSMutableArray *titleArray;

//点击事件
@property (copy, nonatomic) VoidBlock action;

/**
 *  设置背景图片
 *
 *  @param image 图片
 *  @param index 位置
 */
- (void)setBackgroundImage:(UIImage *)image andIndex:(NSInteger )index;


/**
 *  设置字体
 *
 *  @param font 字体
 */
- (void)settitleFont:(UIFont *)font;

/**
 *  设置选中颜色  默认 蓝色
 *
 *  @param color 颜色
 */
- (void)setSelectColor:(UIColor *)color;

/**
 *  设置没有选中颜色 默认 白色
 *
 *  @param color 颜色
 */
- (void)setNormalColor:(UIColor *)color;

/**
 *  设置选中的图片
 *
 *  @param image 图片
 */
- (void)setselectImage:(UIImage *)image;


@end
