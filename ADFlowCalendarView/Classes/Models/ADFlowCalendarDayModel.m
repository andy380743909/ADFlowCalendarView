//
//  ADFlowCalendarDayModel.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/21.
//  Copyright © 2016年 崔盼军. All rights reserved.
//
#import "ADFlowCalendarDayModel.h"

#import "NSCalendar+ADFlowCalendar.h"

@interface ADFlowCalendarDayModel ()

@property (nonatomic, strong) NSDateComponents *fullDateComponents;

@end

@implementation ADFlowCalendarDayModel

- (NSString *)description{
    NSMutableString *desc = [NSMutableString string];
    [desc appendFormat:@"%@--(%@)",self.date,@(self.paddingType)];
    
    return desc;
}

+ (instancetype)DayModelWithDate:(NSDate *)date calendar:(NSCalendar *)calendar todayDate:(NSDate *)todayDate{
    ADFlowCalendarDayModel *obj = [[self alloc] initWithDate:date calendar:calendar todayDate:todayDate];
    return obj;
}

- (instancetype)initWithDate:(NSDate *)date calendar:(NSCalendar *)calendar todayDate:(NSDate *)todayDate;
{
    self = [super init];
    if (self) {
        self.calendar = calendar;
        self.todayDate = todayDate;
        self.date = date;
        [self calculateRalationToToday];
    }
    return self;
}

- (void)calculateRalationToToday{
    NSDate *currentCellDate = self.date;
    BOOL isToday = [self.calendar adflow_isDate:currentCellDate inSameDayAsDate:self.todayDate];
    if (isToday) {
        self.dayRelationToToday = ADFlowCalendarDayRelationToday;
    }else{
        BOOL isPast = [self.calendar adflow_isDate:currentCellDate pastDayToDate:self.todayDate];
        if (isPast) {
            self.dayRelationToToday = ADFlowCalendarDayRelationPast;
        }else{
            self.dayRelationToToday = ADFlowCalendarDayRelationFuture;
        }
    }
}

- (void)generateCacheFullDateComponents{
    if (self.calendar && self.date) {
        _fullDateComponents = [self.calendar components:
                               NSCalendarUnitEra |
                               NSCalendarUnitYear |
                               NSCalendarUnitMonth |
                               NSCalendarUnitDay |
                               NSCalendarUnitWeekday |
                               NSCalendarUnitWeekdayOrdinal |
                               NSCalendarUnitWeekOfMonth |
                               NSCalendarUnitWeekOfYear
                                               fromDate:self.date];
    }
}

#pragma mark -

- (NSInteger)era{
    return _fullDateComponents.era;
}

- (NSInteger)year{
    return _fullDateComponents.year;
}

- (NSInteger)month{
    return _fullDateComponents.month;
}

- (NSInteger)day{
    return _fullDateComponents.day;
}

- (NSInteger)weekday{
    return _fullDateComponents.weekday;
}

- (NSInteger)weekOfMonth{
    return _fullDateComponents.weekOfMonth;
}

- (NSInteger)weekOfYear{
    return _fullDateComponents.weekOfYear;
}


#pragma mark -

- (BOOL)isWeekend{
    return [self weekday] == 1 || [self weekday] == 7;
}

- (BOOL)isToday{
    return self.dayRelationToToday == ADFlowCalendarDayRelationToday;
}

- (BOOL)isPastDay{
    return self.dayRelationToToday == ADFlowCalendarDayRelationPast;
}

- (BOOL)isFutureDay{
    return self.dayRelationToToday == ADFlowCalendarDayRelationFuture;
}

- (BOOL)isPaddingDay{
    return self.paddingType == ADFlowCalendarDateTypePadding;
}

- (BOOL)isGhostDay{
    return self.paddingType == ADFlowCalendarDateTypeGhost;
}

#pragma mark - 

- (void)setDate:(NSDate *)date{
    _date = date;
    [self generateCacheFullDateComponents];
}

- (void)setCalendar:(NSCalendar *)calendar{
    _calendar = calendar;
    [self generateCacheFullDateComponents];
}

@end