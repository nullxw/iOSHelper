//
//  MMDProHUD.h
//  美美哒
//
//  Created by megvii on 14-8-5.
//  Copyright (c) 2014年 megvii. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YTAlertView;

@interface MMDProHUD : NSObject

+ (instancetype)HUDManager;

/**
 *  开启等待动画
 *
 *  @return
 */
- (BOOL)starHUD;

/**
 *  关闭等待动画
 *
 *  @return 
 */
- (BOOL)stopHUD;



@end
