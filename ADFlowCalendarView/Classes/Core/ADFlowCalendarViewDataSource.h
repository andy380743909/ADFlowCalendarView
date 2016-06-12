//
//  ADFlowCalendarViewDataSource.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/19.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ADFlowCalendarView;
@class ADFlowCalendarDayCell;
@class ADFlowCalendarSectionData;
@class ADFlowCalendarWeekdaySymbolsHeadView;
@class ADFlowCalendarMonthHeadView;


//
@protocol ADFlowCalendarViewDataSource <UICollectionViewDataSource/* NSObject */>

@required

- (void)registerViewClassToFlowCalendar:(ADFlowCalendarView *)calendarView;

//- (ADFlowCalendarWeekdaySymbolsHeadView *)weekdaySymbolHeadViewOfFlowCalendarView:(ADFlowCalendarView *)flowCalendarView;

- (NSInteger)flowCalendarView:(ADFlowCalendarView *)flowCalendarView numberOfItemsInSection:(NSInteger)section flowCalendarSectionData:(ADFlowCalendarSectionData *)sectionData;

- (ADFlowCalendarDayCell *)flowCalendarView:(ADFlowCalendarView *)flowCalendarView dayCellAtIndexPath:(NSIndexPath *)indexPath flowCalendarSectionData:(ADFlowCalendarSectionData *)sectionData;

- (ADFlowCalendarSectionData *)flowCalendarView:(ADFlowCalendarView *)flowCalendarView flowCalendarSectionDataInSection:(NSInteger)section;

@optional

- (NSArray *)sectionDatasInFlowCalendarView:(ADFlowCalendarView *)flowCalendarView;

- (ADFlowCalendarMonthHeadView *)flowCalendarView:(ADFlowCalendarView *)flowCalendarView monthHeadViewAtIndexPath:(NSIndexPath *)indexPath flowCalendarSectionData:(ADFlowCalendarSectionData *)sectionData;

@end
