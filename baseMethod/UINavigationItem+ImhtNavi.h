//
//  UINavigationItem+ImhtNavi.h
//  text
//
//  Created by imht-ios on 14-5-29.
//  Copyright (c) 2014年 ymht. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (ImhtNavi)

/**
 *  添加左边 返回 键
 *  @param  target  target
 *  @param  action  action
 */
- (void)addBackItemTarget:(id)target
                   action:(SEL)action;


/**
 *  添加左边 返回 键
 *  @param  target  target
 *  @param  action  action
 */
- (void)addBackItemWithTitle:(NSString *)title
                      Target:(id)target
                      action:(SEL)action;

/**
 *  添加左边键
 *
 *  @param target    target
 *  @param action    action
 *  @param imageName 图片名字
 *  @param soursize  位置偏移
 */
- (void)addLeftItemTarget:(id)target
                   action:(SEL)action
                 andImage:(UIImage *)image
                  andSize:(CGSize )soursize;

/**
 *  添加右边 增加 键
 *  @param  target  target
 *  @param  action  action
 */
- (void)addRightAddItemTarget:(id)target action:(SEL)action;


/**
 *  添加右边键
 *  @param  target  target
 *  @param  action  action
 *  @param  image   背景图片
 */
- (void)addRightItemTarget:(id)target
                    action:(SEL)action
              andImageName:(NSString *)imageName
                   andSize:(CGSize )soursize;



/**
 *  添加右边键
 *  @param  target  target
 *  @param  action  action
 *  @param  title   文字
 */
- (void)addRightItemTarget:(id)target
                    action:(SEL)action
                   andText:(NSString *)title;




@end
