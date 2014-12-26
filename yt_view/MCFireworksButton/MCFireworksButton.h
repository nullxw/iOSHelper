//
//  MCFireworksButton.h
//  MCFireworksButton
//
//  Created by sevennigth on 17/3/14.
//  Copyright (c) 2014 sevennigth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCFireworksButton : UIButton

//粒子效果的图片
@property (strong, nonatomic) UIImage *particleImage;

//粒子效果的倍数
@property (assign, nonatomic) CGFloat particleScale;

//粒子效果的范围
@property (assign, nonatomic) CGFloat particleScaleRange;

//开启动画
- (void)animate;

//显示、关闭动画
- (void)popOutsideWithDuration:(NSTimeInterval)duration;
- (void)popInsideWithDuration:(NSTimeInterval)duration;

@end
