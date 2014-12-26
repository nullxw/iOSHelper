//
//  UIView+DreawLine.h
//  text
//
//  Created by imht-ios on 14-5-20.
//  Copyright (c) 2014年 ymht. All rights reserved.
//

/*
 使用说明：
        直接用 View 调用即可。
 */


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>



@interface UIView (DrawLine)

/**
 *  简单的 View 四周画线，仅作测试使用
 */
- (void)drawLine;

/**
 *  给View增加边框
 *  @param  radius 变的角度
 *  @param  width  线条宽度
 *  @param  color  线条颜色
 */
- (void)drawRoundBoderWidth:(CGFloat)width andColor:(UIColor *)color andRadius:(CGFloat)radius;


/**
 *  在View上画一条直线
 *  @param  spoint 起点坐标
 *  @param  epoint 终点坐标
 *  @param  width  线条宽度
 *  @param  color  线条颜色
 */
- (void)drawLineWidth:(CGFloat)width
                color:(UIColor *)color
           startPoint:(CGPoint )spoint
             endPoint:(CGPoint)epoint;

/**
 *  画三角形
 *  @param one     one description
 *  @param two     two description
 *  @param three   three description
 *  @param color   填充颜色
 */
- (void)drawTrigonWith:(CGContextRef)context
              pointOne:(CGPoint)one
              pointTwo:(CGPoint)two
            pointThree:(CGPoint)three
             fillColor:(UIColor *)color;

/**
 *  把View转化为图片
 */
-(UIImage *)getImageFromView;




/**
 *  删除当前视图的所有子视图
 */
- (void)removeSubviews;


@end
