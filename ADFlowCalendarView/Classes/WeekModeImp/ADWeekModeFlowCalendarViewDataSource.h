//
//  ADMonthModeFlowCalendarViewDataSource.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/21.
//  Copyright © 2016年 崔盼军. All rights reserved.
//
#import "ADFlowCalendarViewDataSource.h"


typedef NS_ENUM(NSInteger, ADWeekModeFlowCalendarPaddingType) {
    ADWeekModeFlowCalendarPaddingNone,
    ADWeekModeFlowCalendarPaddingWeek
};

@interface ADWeekModeFlowCalendarViewDataSource : NSObject<ADFlowCalendarViewDataSource>

@property (nonatomic, copy) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *today;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, assign) ADWeekModeFlowCalendarPaddingType paddingType;

// override this to do some customize initializing
- (void)commonInit;

- (NSString *)weekdaySymbolForWeekday:(NSUInteger)weekday;

@end