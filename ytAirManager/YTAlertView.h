//
//  YTAlertView.h
//  ImhtDoctor
//
//  Created by imht-ios on 14-7-3.
//  Copyright (c) 2014年 imht. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  动画类型
 */
typedef NS_ENUM(int, animationType) {

    animation_fade = 10,    //default  淡入淡出
    animation_fly  = 11,    //         侧边飞入
};

/**
 *  侧边飞入方向
 */
typedef NS_ENUM(int, animation_fly_direction) {
    fly_top     = 10,       //          顶部
    fly_bottom  = 11,       //default   底部
    fly_left    = 12,       //          左边
    fly_right   = 13,       //          右边
};


@interface YTAlertView : UIView
{
    
}

/**
 *  目标view
 */
@property (strong, nonatomic) UIView *sourceView;

/**
 *  底部的 alpha 值 默认0.4
 */
@property (assign, nonatomic) CGFloat backgroundColorAlpha;

@property (assign, nonatomic) animationType animationType;
@property (assign, nonatomic) animation_fly_direction flyDirection;

/**
 *  初始化方法   !!!!!必须使用该方法!!!!!
 *
 *  @param sView  目标view
 *  @param sFrame 目标frame
 *
 *  @return
 */
- (instancetype)initWithSourceView:(UIView *)sView
                      frameOfsView:(CGRect)sFrame;

/**
 *  自动隐藏的时间
 *
 *  @param time 间隔
 */
- (void)autoHideWithtime:(NSTimeInterval)time;

/**
 *  隐藏掉底部的view - 做成通知的效果
 *
 *  @param hide 是否隐藏
 */
- (void)hideBottomView:(BOOL)hide;

/**
 *  显示
 *
 *  @return 显示是否成功
 */
- (BOOL)showWithAnimation:(BOOL)animation;



/**
 *  隐藏
 *
 *  @return 隐藏是否成功
 */
- (BOOL)hideWithAnimation:(BOOL)animation;

//关闭点击就消失的手势
- (void)closeGestHide;

@end
