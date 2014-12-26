//
//  YTCalendarView.h
//  CalendarView
//
//  Created by seven night on 5/8/13.
//  Copyright (c) 2014 visionhacker. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UIColor+expanded.h"

#define kVRGCalendarViewTopBarHeight 60
#define kVRGCalendarViewWidth [UIScreen mainScreen].bounds.size.width

#define kVRGCalendarViewDayWidth ([UIScreen mainScreen].bounds.size.width - 12) / 7
#define kVRGCalendarViewDayHeight ([UIScreen mainScreen].bounds.size.width - 12) / 7


typedef NS_ENUM(NSInteger, YTMarkStyle){
    markRound,          //圆形
    markRect,           //方形
};


@protocol YTCalendarViewDelegate;

@interface YTCalendarView : UIView {
    
    BOOL isAnimating;
    BOOL prepAnimationPreviousMonth;
    BOOL prepAnimationNextMonth;
}

@property (nonatomic, assign) id <YTCalendarViewDelegate> delegate;

@property (nonatomic, assign) BOOL hasBorder;              //默认：有 边框
@property (nonatomic, strong) UIColor *backColor;           //默认： 白色 背景颜色

@property (nonatomic, strong) NSDate *currentMonth;         //默认 今天

@property (nonatomic, strong) NSArray *markedDates;         //要标记位置的数组，允许为nil，但必须为ytmarkmodel

@property (nonatomic, strong) UIColor *todayMarkColor;                  //默认 红色 -- 标记今天
@property (nonatomic, assign) YTMarkStyle todayMarkStyle;               //default round

@property (nonatomic, strong) UIColor *selectedColor;                   //默认 蓝色 -- 标记选中
@property (nonatomic, assign) YTMarkStyle selectedMarkStyle;             //default round


@property (nonatomic, getter = calendarHeight) CGFloat calendarHeight;
@property (nonatomic, strong, getter = selectedDate) NSDate *selectedDate;

@property (nonatomic, strong) NSDate *maxDate;          //默认 没有最大限制
@property (nonatomic, strong) NSDate *minDate;          //默认 没有最小限制

//界面重置
-(void)reset;

-(void)markDates:(NSArray *)dates;

-(NSInteger)numRows;

-(void)updateSize;

-(UIImage *)drawCurrentState;

@end


@protocol YTCalendarViewDelegate <NSObject>

-(void)calendarView:(YTCalendarView *)calendarView switchedToMonth:(NSInteger)month targetHeight:(CGFloat)targetHeight animated:(BOOL)animated;
-(void)calendarView:(YTCalendarView *)calendarView dateSelected:(NSDate *)date;

@end


/**
 *  如果不进行参数设置，默认为今天
 */
@interface YTMarkModel : NSObject

@property (nonatomic, assign) NSInteger MYear;
@property (nonatomic, assign) NSInteger MMonth;
@property (nonatomic, assign) NSInteger MDay;
@property (nonatomic, strong) UIColor   *MColor;                //default red
@property (nonatomic, assign) YTMarkStyle markStyle;            //default round

@end







