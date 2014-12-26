//
//  UIView+Shadow.m
//  美美哒
//
//  Created by megvii on 14-8-11.
//  Copyright (c) 2014年 megvii. All rights reserved.
//

#import "UIView+Shadow.h"

@implementation UIView (Shadow)

- (void)shadowWithColor:(UIColor *)color offset:(CGSize )size opacity:(CGFloat)opa radius:(CGFloat)rad
{
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = opa;
    self.layer.shadowOffset = size;
    self.layer.shadowRadius = rad;
    self.layer.masksToBounds = NO;
}

- (UIImage *)DrawGradient
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 1);
    CGContextRef selfRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(selfRef);
    
    static const CGFloat g0[] = {0.7, 1.0, 0.6, 1.0, 0.5, 1.0, 0.45, 1.0};
    static const CGFloat l0[] = {0.0, 0.47, 0.53, 1.0};
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, g0, l0, 3);

    CGContextDrawLinearGradient(selfRef,
                                gradient,
                                CGPointMake(0.0,0.0),
                                CGPointMake(0.0,self.bounds.size.height),
                                0);
    
    UIImage *sourceImage = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    UIGraphicsEndImageContext();
    CGContextRestoreGState(selfRef);
    CGColorSpaceRelease(colorSpace);
    
    return sourceImage;
}

@end
