//
//  MyNotification.h
//  TYAlertTexst
//
//  Created by imht-ios on 14-7-3.
//  Copyright (c) 2014年 ioszyt. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyNotification : NSObject

+ (instancetype)shareInstand;

//实时 推送消息。跟系统 推送类似，可以再APP开启时推送。
- (void)pushWithTitle:(NSString *)string;

@end
