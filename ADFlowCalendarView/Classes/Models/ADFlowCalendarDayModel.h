//
//  ADFlowCalendarDayModel.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/21.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADFlowCalendarDefine.h"

@interface ADFlowCalendarDayModel : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, readonly) NSDateComponents *fullDateComponents;

@property (nonatomic, copy) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *todayDate;

@property (nonatomic, assign, getter=isWeekend, readonly) BOOL weekend;

@property (nonatomic, assign) ADFlowCalendarDayRelation dayRelationToToday;

@property (nonatomic, assign, getter=isToday, readonly) BOOL today;
@property (nonatomic, assign, getter=isPastDay, readonly) BOOL pastDay;
@property (nonatomic, assign, getter=isFutureDay, readonly) BOOL futureDay;


@property (nonatomic, assign) ADFlowCalendarDatePaddingType paddingType;

// paddingDay 和 ghostDay 是互斥状态
@property (nonatomic, assign, getter=isPaddingDay, readonly) BOOL paddingDay; // 会显示出来，但是不能操作
@property (nonatomic, assign, getter=isGhostDay, readonly) BOOL ghostDay; // 不显示，只占位置（collectionView布局，有了这个占位后，布局就简单很多）


- (NSInteger)weekday;


+ (instancetype)DayModelWithDate:(NSDate *)date calendar:(NSCalendar *)calendar todayDate:(NSDate *)todayDate;
- (instancetype)initWithDate:(NSDate *)date calendar:(NSCalendar *)calendar todayDate:(NSDate *)todayDate;

@end
