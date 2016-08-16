//
//  NSCalendar+ADFlowCalendar.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/21.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "NSCalendar+ADFlowCalendar.h"

@implementation NSCalendar (ADFlowCalendar)

- (NSUInteger)adflow_daysInWeek{
    return [self.weekdaySymbols count];
}

- (NSArray *)adflow_standaloneVeryShortWeekdaySymbols{
    NSArray *symbolsArr = [self veryShortStandaloneWeekdaySymbols];
    NSMutableArray *result = [NSMutableArray array];
    NSUInteger calendarFirstWeekday = self.firstWeekday;
    if (calendarFirstWeekday > 1) {
        NSIndexSet *indexSetHead = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(calendarFirstWeekday-1, symbolsArr.count - calendarFirstWeekday + 1)];
        NSIndexSet *indexSetTail = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, calendarFirstWeekday - 1)];
        
        [result addObjectsFromArray:[symbolsArr objectsAtIndexes:indexSetHead]];
        [result addObjectsFromArray:[symbolsArr objectsAtIndexes:indexSetTail]];
        
        return [NSArray arrayWithArray:result];
    }else{
        return symbolsArr;
    }
}

- (NSDate *)firstDayOfCalendarUnit:(NSCalendarUnit)calendarUnit withDate:(NSDate *)date{
    
//    if (calendarUnit != NSCalendarUnitYear || calendarUnit != NSCalendarUnitMonth || calendarUnit != NSCalendarUnitWeekOfMonth || calendarUnit != NSCalendarUnitWeekOfYear) {
//        return nil;
//    }
    
    NSDate *firstDayOfUnit;
    BOOL result = [self rangeOfUnit:calendarUnit startDate:&firstDayOfUnit interval:NULL forDate:date];
    if (!result) {
        NSLog(@"");
    }
    return firstDayOfUnit;
}

- (NSDate *)lastDayOfCalendarUnit:(NSCalendarUnit)calendarUnit withDate:(NSDate *)date{
    
//    if ((calendarUnit&NSCalendarUnitYear) != NSCalendarUnitYear || (calendarUnit&NSCalendarUnitMonth) != NSCalendarUnitMonth || calendarUnit != NSCalendarUnitWeekOfMonth || calendarUnit != NSCalendarUnitWeekOfYear) {
//        return nil;
//    }
    
    NSDate *firstDayOfUnit = [self firstDayOfCalendarUnit:calendarUnit withDate:date];
    
    NSInteger addDays = 0;
    
    switch (calendarUnit) {
        case NSCalendarUnitYear:
        {
            addDays = [self numberOfDaysInYearWithDate:firstDayOfUnit] - 1;
        }
            break;
        case NSCalendarUnitMonth:
        {
            addDays = [self numberOfDaysInMonthWithDate:firstDayOfUnit] - 1;
        }
            break;
        case NSCalendarUnitWeekOfMonth:
        {
            addDays = [self numberOfDaysInWeekOfMonthWithDate:firstDayOfUnit] - 1;
        }
            break;
        default:
            break;
    }
    
    NSDateComponents *addComponents = [NSDateComponents new];
    addComponents.day = addDays;
    // this is iOS 8 API
    //    NSDate *lastDay = [self dateByAddingUnit:NSCalendarUnitDay value:addDays toDate:firstDayOfUnit options:0];
    NSDate *lastDay = [self dateByAddingComponents:addComponents toDate:firstDayOfUnit options:0];
    
    return lastDay;
}

#pragma mark - 

- (NSUInteger)adflow_lastWeekday{
    return (self.firstWeekday - 1)?:7;
}

- (NSUInteger)adflow_indexOfWeekday:(NSInteger)weekday{
    if (weekday < 1 || weekday > 7) {
        return NSNotFound;
    }
    
    if (weekday >= self.firstWeekday) {
        return weekday - self.firstWeekday;
    }else{
        return (7 - self.firstWeekday + 1) + (weekday - 1);
    }
}

// 找到date处在的星期的开始
- (NSDate *)firstWeekdayWithDate:(NSDate *)date;
{
    NSDateComponents *fullComponents = [self dateComponentsFullFromDate:date];
    if (fullComponents.weekday == self.firstWeekday) {
        return date;
    }
    
    NSUInteger indexInWeek = [self adflow_indexOfWeekday:fullComponents.weekday];
    
    NSDateComponents *minusComponents = [NSDateComponents new];
    minusComponents.day = -indexInWeek;
    
    return [self dateByAddingComponents:minusComponents toDate:date options:0];
}

// 找到date处在的星期的结束
- (NSDate *)lastWeekdayWithDate:(NSDate *)date;
{
    NSDateComponents *fullComponents = [self dateComponentsFullFromDate:date];
    if (fullComponents.weekday == self.adflow_lastWeekday) {
        return date;
    }
    
    NSUInteger indexInWeek = [self adflow_indexOfWeekday:fullComponents.weekday];
    
    NSDateComponents *addComponents = [NSDateComponents new];
    addComponents.day = (7 - indexInWeek - 1);
    
    return [self dateByAddingComponents:addComponents toDate:date options:0];
}

#pragma mark -

- (NSUInteger)numberOfDaysInYearWithDate:(NSDate *)date{
    
    NSRange range = [self rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date];
    if (range.location != NSNotFound && range.length != NSNotFound) {
        return range.length;
    }
    return 0;
}

- (NSUInteger)numberOfDaysInMonthWithDate:(NSDate *)date{
    
    NSRange range = [self rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    if (range.location != NSNotFound && range.length != NSNotFound) {
        return range.length;
    }
    return 0;
}

- (NSUInteger)numberOfDaysInWeekOfMonthWithDate:(NSDate *)date{
    
    NSRange range = [self rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:date];
    if (range.location != NSNotFound && range.length != NSNotFound) {
        return range.length;
    }
    return 0;
}

- (NSUInteger)numberOfDaysInWeekOfYearWithDate:(NSDate *)date{
    
    NSRange range = [self rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfYear forDate:date];
    if (range.location != NSNotFound && range.length != NSNotFound) {
        return range.length;
    }
    return 0;
}

- (NSDateComponents *)dateComponentsFullFromDate:(NSDate *)date{
    NSDateComponents *components = [self components:
                                    NSCalendarUnitEra |
                                    NSCalendarUnitYear |
                                    NSCalendarUnitMonth |
                                    NSCalendarUnitDay |
                                    NSCalendarUnitWeekday |
                                    NSCalendarUnitWeekdayOrdinal |
                                    NSCalendarUnitWeekOfMonth |
                                    NSCalendarUnitWeekOfYear
                                           fromDate:date];
    return components;
}

- (NSDateComponents *)dateComponentsYMDFromDate:(NSDate *)date{
    NSDateComponents *components = [self components:
                                    NSCalendarUnitEra |
                                    NSCalendarUnitYear |
                                    NSCalendarUnitMonth |
                                    NSCalendarUnitDay
                                           fromDate:date];
    return components;
}

#pragma mark - Relation

- (BOOL)isSameMonth:(NSDate *)date otherDate:(NSDate *)otherDate{
    
    NSDateComponents *dateComponents = [self dateComponentsYMDFromDate:date];
    NSDateComponents *dateComponents1 = [self dateComponentsYMDFromDate:otherDate];
    
    BOOL result = dateComponents.era == dateComponents1.era &&
    dateComponents.year == dateComponents1.year &&
    dateComponents.month == dateComponents1.month;
    return result;
}

- (BOOL)adflow_isDate:(NSDate *)date1 pastDayToDate:(NSDate *)date2;
{
    NSDateComponents *dateComponents = [self dateComponentsYMDFromDate:date1];
    NSDateComponents *dateComponents1 = [self dateComponentsYMDFromDate:date2];
    if (dateComponents.era < dateComponents1.era) {
        return YES;
    }else if (dateComponents.era > dateComponents1.era) {
        return NO;
    }else{
        if (dateComponents.year < dateComponents1.year) {
            return YES;
        }else if (dateComponents.year > dateComponents1.year) {
            return NO;
        }else {
            if (dateComponents.month < dateComponents1.month) {
                return YES;
            }else if (dateComponents.month > dateComponents1.month) {
                return NO;
            }else{
                if (dateComponents.day < dateComponents1.day) {
                    return YES;
                }else if (dateComponents.day > dateComponents1.day) {
                    return NO;
                }else{
                    return NO;
                }
            }
        }
    }
    return NO;
}

- (BOOL)adflow_isDate:(NSDate *)date1 inSameDayAsDate:(NSDate *)date2;
{
    NSDateComponents *dateComponents = [self dateComponentsYMDFromDate:date1];
    NSDateComponents *dateComponents1 = [self dateComponentsYMDFromDate:date2];
    BOOL result = (dateComponents.era == dateComponents1.era &&
                   dateComponents.year == dateComponents1.year &&
                   dateComponents.month == dateComponents1.month &&
                   dateComponents.day == dateComponents1.day);
    return result;
}

- (BOOL)adflow_isDate:(NSDate *)date1 futureDayToDate:(NSDate *)date2;
{
    NSDateComponents *dateComponents = [self dateComponentsYMDFromDate:date1];
    NSDateComponents *dateComponents1 = [self dateComponentsYMDFromDate:date2];
    if (dateComponents.era > dateComponents1.era) {
        return YES;
    }else if (dateComponents.era < dateComponents1.era) {
        return NO;
    }else{
        if (dateComponents.year > dateComponents1.year) {
            return YES;
        }else if (dateComponents.year < dateComponents1.year) {
            return NO;
        }else {
            if (dateComponents.month > dateComponents1.month) {
                return YES;
            }else if (dateComponents.month < dateComponents1.month) {
                return NO;
            }else{
                if (dateComponents.day > dateComponents1.day) {
                    return YES;
                }else if (dateComponents.day < dateComponents1.day) {
                    return NO;
                }else{
                    return NO;
                }
            }
        }
    }
    return NO;
}

@end