//
//  UIView+DreawLine.m
//  text
//
//  Created by imht-ios on 14-5-20.
//  Copyright (c) 2014年 ymht. All rights reserved.
//

#import "UIView+DrawLine.h"

@implementation UIView (DrawLine)

- (void)drawLine
{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:0.0]; //设置矩圆角半径
    [self.layer setBorderWidth:1.0f];   //边框宽度
    [self.layer setBorderColor:[UIColor blackColor].CGColor];//边框颜色
}

- (void)drawRoundBoderWidth:(CGFloat)width andColor:(UIColor*)color andRadius:(CGFloat)radius
{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:radius]; //设置矩圆角半径
    [self.layer setBorderWidth:width];   //边框宽度
    [self.layer setBorderColor:color.CGColor];//边框颜色
}

/**
 *  在view上划线，本方法采用的生成一个新的layer，然后加载上去。
 */
- (void)drawLineWidth:(CGFloat)width
                color:(UIColor *)color
           startPoint:(CGPoint )spoint
             endPoint:(CGPoint)epoint
{
    CAShapeLayer *lineShape = nil;
    CGMutablePathRef linepath = nil;
    
    linepath = CGPathCreateMutable();
    lineShape = [CAShapeLayer layer];
    
    lineShape.lineWidth = width;
    lineShape.lineCap = kCALineCapRound;
    lineShape.strokeColor = color.CGColor;
    
    CGPathMoveToPoint(linepath, NULL, spoint.x, spoint.y);
    CGPathAddLineToPoint(linepath, NULL, epoint.x, epoint.y);
    
    lineShape.path = linepath;
    CGPathRelease(linepath);
    
    [self.layer addSublayer:lineShape];
}



-(UIImage *)getImageFromView
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)drawTrigonWith:(CGContextRef)context
              pointOne:(CGPoint)one
              pointTwo:(CGPoint)two
            pointThree:(CGPoint)three
             fillColor:(UIColor *)color{
    CGContextMoveToPoint(context, one.x, one.y);
    CGContextAddLineToPoint(context, two.x, two.y);
    CGContextAddLineToPoint(context, three.x, three.y);
//    CGContextAddLineToPoint(context, xmargin+arrowSize/1.5, ymargin);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
}



#pragma mark ---



/**
 *  删除当前视图的所有子视图
 */
- (void)removeSubviews{
    for(UIView *v in self.subviews) {
		[v removeFromSuperview];
	}
}
@end
