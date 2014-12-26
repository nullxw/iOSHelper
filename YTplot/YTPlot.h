//
//  YTPlot.h
//  PlotTest
//
//  Created by 张英堂 on 14/10/31.
//  Copyright (c) 2014年 visionhacker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface plotLine : NSObject

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;

@end


@interface plotModel : NSObject

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, copy) NSString *x_string;

@end





@interface YTPlot : UIView

@property (nonatomic, assign) CGFloat axis_y_max;
@property (nonatomic, assign) CGFloat axis_y_min;
@property (nonatomic, strong) NSMutableArray *numArray; //必须plotmodel 数组
@property (nonatomic, strong) plotLine *lineStyle;



@end
