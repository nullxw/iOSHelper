//
//  UIView+Shadow.h
//  美美哒
//
//  Created by megvii on 14-8-11.
//  Copyright (c) 2014年 megvii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Shadow)


/**
 *  给view添加阴影
 *
 *  @param color 阴影颜色
 *  @param size  大小
 *  @param opa   不透明度
 *  @param rad   半径
 */
- (void)shadowWithColor:(UIColor *)color offset:(CGSize )size opacity:(CGFloat)opa radius:(CGFloat)rad;


//颜色逐渐模糊
- (UIImage *)DrawGradient;


@end
