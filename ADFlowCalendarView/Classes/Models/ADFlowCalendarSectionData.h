//
//  ADFlowCalendarSectionData.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/20.
//  Copyright © 2016年 崔盼军. All rights reserved.
//


#import "ADFlowCalendarDefine.h"

/**
 *  用于表示collectionView里一个section内 日期的范围以及补全日期范围
 */

NS_ASSUME_NONNULL_BEGIN


@class ADFlowCalendarDayModel;

@interface ADFlowCalendarSectionData : NSObject

@property (nonatomic, copy) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *today;

@property (nonatomic, strong) NSDateComponents *startDateComponents;
@property (nonatomic, strong) NSDateComponents *endDateComponents;

// 补全的起始和结束日期，如果为nil,则表示不用补
@property (nonatomic, strong, nullable) NSDateComponents *paddedStartDateComponents;
@property (nonatomic, strong, nullable) NSDateComponents *paddedEndDateComponents;

@property (nonatomic, strong, readonly) NSArray *dayModelArray;


+ (instancetype)SectionDataWithStartDateComponents:(NSDateComponents *)startDateComponents
                                 endDateComponents:(NSDateComponents *)endDateComponents
                                          calendar:(NSCalendar *)calendar;

+ (instancetype)SectionDataWithStartDateComponents:(NSDateComponents *)startDateComponents
                                 endDateComponents:(NSDateComponents *)endDateComponents
                         paddedStartDateComponents:(nullable NSDateComponents *)paddedStartDateComponents
                           paddedEndDateComponents:(nullable NSDateComponents *)paddedEndDateComponents
                                          calendar:(NSCalendar *)calendar;

- (instancetype)initWithStartDateComponents:(NSDateComponents *)startDateComponents
                          endDateComponents:(NSDateComponents *)endDateComponents
                                   calendar:(NSCalendar *)calendar;

- (instancetype)initWithStartDateComponents:(NSDateComponents *)startDateComponents
                          endDateComponents:(NSDateComponents *)endDateComponents
                  paddedStartDateComponents:(nullable NSDateComponents *)paddedStartDateComponents
                    paddedEndDateComponents:(nullable NSDateComponents *)paddedEndDateComponents
                                   calendar:(NSCalendar *)calendar;

- (NSDate *)firstDayOfFirstWeek;
- (NSDate *)lastDayOfLastWeek;


// 不同显示模式下，sectionData代表的意义不同，可以是年模式，月份模式、单周模式

- (NSDateComponents *)monthComponents; // 取startDate所在的月份
- (NSDateComponents *)weekComponents; //取startDate所在的weekOfYear

//

//- (nullable NSDateComponents *)componentsAtIndex:(NSInteger)index useCalendar:(NSCalendar *)calendar;
//
//- (NSDate *)dateAtIndex:(NSInteger)index useCalendar:(NSCalendar *)calendar;

- (NSUInteger)numberOfWeeksUseCalendar:(NSCalendar *)calendar;
- (NSUInteger)numberOfWeeks;

- (ADFlowCalendarDayModel *)dayModelAtIndex:(NSInteger)index;


@end

@interface ADFlowCalendarSectionData (ContainRelation)

- (NSInteger)indexOfDateComponents:(NSDateComponents *)dataComponents useCalendar:(NSCalendar *)calendar;

@end

NS_ASSUME_NONNULL_END