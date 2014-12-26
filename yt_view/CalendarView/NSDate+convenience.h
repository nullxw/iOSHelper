//
//  NSDate+convenience.h
//
//  Created by seven night on 5/8/13.
//  Copyright (c) 2014 visionhacker. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  一个对 日期处理的 类目
 */
@interface NSDate (Convenience)

-(NSDate *)offsetMonth:(int)numMonths;
-(NSDate *)offsetDay:(int)numDays;
-(NSDate *)offsetHours:(int)hours;
-(NSInteger)numDaysInMonth;
-(NSInteger)firstWeekDayInMonth;
-(NSInteger)year;
-(NSInteger)month;
-(NSInteger)day;

+(NSDate *)dateStartOfDay:(NSDate *)date;
+(NSDate *)dateStartOfWeek;
+(NSDate *)dateEndOfWeek;

+(NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

+(NSDate *)koalaStarDate;


@end
