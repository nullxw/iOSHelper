//
//  BaseViewController.h
//  text
//
//  Created by imht-ios on 14-4-18.
//  Copyright (c) 2014年 ymht. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UINavigationItem+ImhtNavi.h"

#import "YTMacro.h"

@interface BaseViewController : UIViewController<UIGestureRecognizerDelegate>



//添加返回键，子类调用即可
- (void)addBackNaviItem;


- (void)addNavigationTitle:(NSString *)title withFont:(UIFont *)font withColor:(UIColor *)color;

- (void)setNaviTitle:(NSString *)title;

/**
 *  启动屏幕大菊花
 *
 *  @param text  大菊花上的字
 *  @param image 大菊花的背景（两者只能有一个）
 */
- (void)starMumWithTitle:(NSString *)text
                topImage:(UIImage *)image;

/**
 *  停止动画
 *
 *  @param delay 延迟时间停止
 */
- (void)stopMumWithAfterDelay:(NSTimeInterval)delay;

- (void)alertWithWithTitle:(NSString *)title message:(NSString *)message  cancelButtonTitle:(NSString *)cancel;

- (void)addBackGest;

- (void)backNextVC:(id)sender;

- (void)addDownColor:(UIColor *)color tag:(id)tag action:(SEL)action;


@end



