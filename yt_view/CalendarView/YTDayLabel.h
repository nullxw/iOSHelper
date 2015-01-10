//
//  YTDayLabel.h
//  KoalaPerson
//
//  Created by 张英堂 on 14/12/17.
//  Copyright (c) 2014年 visionhacker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTMarkModel;

@interface YTDayLabel : UIControl

@property (nonatomic, strong) YTMarkModel *model;

@property (nonatomic, copy) NSString *dateDayString;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) BOOL isCurrutMonth;

//- (void)addTag:(id)tagtar action:()

- (void)clearAllEffect;


@end
