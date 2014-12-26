//
//  UIImage+ytImage.h
//  mall
//
//  Created by zyt on 14-9-17.
//  Copyright (c) 2014年 megvii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ytImage)

//根据当前重力改变图片的角度，修正拍完照片后图片旋转问题。
- (UIImage *)fixOrientation:(UIImage *)aImage;


//从bundle中读取图片
+ (UIImage *)imageReadBund:(NSString *)imageName;

@end
