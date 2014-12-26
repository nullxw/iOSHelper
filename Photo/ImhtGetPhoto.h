//
//  ImhtGetPhoto.h
//  text
//
//  Created by imht-ios on 14-5-20.
//  Copyright (c) 2014年 ymht. All rights reserved.
//


/*
 使用要求：
        必须外边给予 VC 的指针，（必须）
        设置图片的质量的压缩倍数（默认 0.2）
 
 使用说明：
        只需要调用一下开启即可。
        关闭方法 基本不需要调用
        相册，相机都是使用 模态 视图。
 */

#import <Foundation/Foundation.h>

#import "YTMacro.h"
#import "APIMacro.h"

@interface ImhtGetPhoto : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>


/**
 *  必须给与 viewcontroller 的指针
 *  @param  Viewcontroller  viewcontroller指针
 */
@property (nonatomic, strong) UIViewController *viewController;



/**
 *  设置图片压缩倍数 （质量压缩，非 大小 压缩）
 *  @param  cutscale   压缩倍数
 */
@property (nonatomic, assign) CGFloat cutScale;




/**
 *  必须用该初始化方法
 *  @param  finsh  添加相片结束时候的事件 block
 *  @param  error  添加相片结束时候的错误 block
*/
- (instancetype)initWithViewController:(UIViewController*)vc andFinsh:(void(^)(id))finsh andError:(void (^)(void))error;


/**
 *  开启相机
 */
- (void)openMenu;


/**
 *  关闭相机
 *  说明： 外边不用调用
 */
- (void)closeMenu;


@end
