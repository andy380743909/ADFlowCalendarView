//
//  NSCalendar+ADFlowCalendar.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/21.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (ADFlowCalendar)

- (NSUInteger)adflow_daysInWeek;

- (NSArray *)adflow_standaloneVeryShortWeekdaySymbols;

- (NSDate *)firstDayOfCalendarUnit:(NSCalendarUnit)calendarUnit withDate:(NSDate *)date;
- (NSDate *)lastDayOfCalendarUnit:(NSCalendarUnit)calendarUnit withDate:(NSDate *)date;

//
- (NSUInteger)adflow_lastWeekday;
- (NSUInteger)adflow_indexOfWeekday:(NSInteger)weekday;

// 找到date处在的星期的开始
- (NSDate *)firstWeekdayWithDate:(NSDate *)date;
// 找到date处在的星期的结束
- (NSDate *)lastWeekdayWithDate:(NSDate *)date;

- (NSUInteger)numberOfDaysInYearWithDate:(NSDate *)date;
- (NSUInteger)numberOfDaysInMonthWithDate:(NSDate *)date;
- (NSUInteger)numberOfDaysInWeekOfMonthWithDate:(NSDate *)date;
- (NSUInteger)numberOfDaysInWeekOfYearWithDate:(NSDate *)date;

// past now future

- (BOOL)adflow_isDate:(NSDate *)date1 pastDayToDate:(NSDate *)date2;
- (BOOL)adflow_isDate:(NSDate *)date1 inSameDayAsDate:(NSDate *)date2;
- (BOOL)adflow_isDate:(NSDate *)date1 futureDayToDate:(NSDate *)date2;

- (NSDateComponents *)dateComponentsYMDFromDate:(NSDate *)date;
- (NSDateComponents *)dateComponentsFullFromDate:(NSDate *)date;

@end
