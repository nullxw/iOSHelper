//
//  ImhtAnimation.h
//  text
//
//  Created by imht-ios on 14-6-4.
//  Copyright (c) 2014年 ymht. All rights reserved.
//



//使用该类的单例来生成，调用动画。 或者把动画写成   类方法



#import <Foundation/Foundation.h>


@interface ImhtAnimation : NSObject


/**
 *  上拉动画效果
 */
+ (CATransition *)moveToTopAnimation;

/**
 *  消失的动画
 */
+ (CATransition *)animationOut;

//抖动
+ (CAAnimation *)animationWaggle:(UIView *)view repeatCount:(NSInteger)count;

@end
