//
//  ADYearModeFlowCalendarViewDataSource.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/21.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADFlowCalendarViewDataSource.h"

@class ADFlowCalendarView;

typedef NS_ENUM(NSInteger, ADYearModeFlowCalendarPaddingType) {
    ADYearModeFlowCalendarPaddingNone,
    ADYearModeFlowCalendarPaddingWeek,
    ADYearModeFlowCalendarPaddingMonth
};

@interface ADYearModeFlowCalendarViewDataSource : NSObject<ADFlowCalendarViewDataSource>

@property (nonatomic, copy) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *today;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, assign) ADYearModeFlowCalendarPaddingType paddingType;


- (ADFlowCalendarSectionData *)sectionDataForSection:(NSInteger)section;

- (NSString *)monthTitleForSectionData:(ADFlowCalendarSectionData *)sectionData;

- (void)generateCacheSectionData;

@end
