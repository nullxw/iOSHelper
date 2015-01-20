//
//  APPUpdateManager.h
//  KoalaPerson
//
//  Created by 张英堂 on 14/12/18.
//  Copyright (c) 2014年 visionhacker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPUpdateManager : NSObject<UIAlertViewDelegate>


+ (instancetype)checkUpdate;

- (void)check;

@end
