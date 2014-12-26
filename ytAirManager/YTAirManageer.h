//
//  AirManageer.h
//  AirTest
//
//  Created by zyt on 14-8-14.
//  Copyright (c) 2014年 megvii. All rights reserved.
//  bulid :  1.0

#import <UIKit/UIKit.h>

typedef void(^ytVoidBlock)(void);

/**
 *  使用方法，该类是集成与 uiviewcontroller， 只需要设置为 window的rootVC就行
 */

@interface YTAirManageer : UIViewController

+ (instancetype)shareAirManager;

/**
 *  动画的四个时态
 */
@property (copy, nonatomic) ytVoidBlock menuShowimgBlock;
@property (copy, nonatomic) ytVoidBlock menuHidimgBlock;

@property (copy, nonatomic) ytVoidBlock menuWillShowBLock;
@property (copy, nonatomic) ytVoidBlock menuWillHideBLock;

@property (copy, nonatomic) ytVoidBlock menuDidShowBLock;
@property (copy, nonatomic) ytVoidBlock menuDidHideBLock;

//是否显示 menu菜单
@property (assign, nonatomic, readonly) BOOL isShowMenu;

//设置两个vc 首次使用的时候使用该方法
- (void)setAirViewController:(UIViewController *)airViewController
       andMenuViewController:(UIViewController *)menuVC;

/**
 * 显示/隐藏 菜单栏    使用之前必须设置menuVC ,还有 airVC
 *  @return 是否显示成功
 */
- (BOOL)showMenu;

/**
 *  更改airviewcontroller
 *  @param viewController
 */
- (void)chageAirViewController:(UIViewController *)viewController animation:(BOOL)animation;

/**
 *  开启手势
 */
- (void)openGest;

/**
 *  关闭手势功能
 */
- (void)closeGest;

- (UIViewController*)getAirViewController;


//进行比较即将创建的Air对象是否与原来的时一个类
- (BOOL)compareViewController:(Class)mmdclass;




@end

