//
//  ADMonthModeFlowCalendarViewDataSource.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/21.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADMonthModeFlowCalendarViewDataSource.h"

#import "ADFlowCalendarDefine.h"
#import "NSCalendar+ADFlowCalendar.h"

#import "ADFlowCalendarView.h"
#import "ADFlowCalendarMonthHeadView.h"
#import "ADFlowCalendarDayCell.h"
#import "ADFlowCalendarSectionData.h"
#import "ADFlowCalendarDayModel.h"

@interface ADMonthModeFlowCalendarViewDataSource ()

@property (nonatomic, assign) BOOL isDataDirty;
@property (nonatomic, strong) ADFlowCalendarSectionData *monthSectionData;

@end

@implementation ADMonthModeFlowCalendarViewDataSource

static NSString *cellReuseIdentifier = @"ADFlowCalendarDayCell";
static NSString *monthHeadViewReuseIdentifier = @"ADFlowCalendarMonthHeadView";

- (instancetype)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
}

- (void)registerViewClassToFlowCalendar:(ADFlowCalendarView *)calendarView{
    
    [calendarView.collectionView registerClass:[ADFlowCalendarDayCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
    [calendarView.collectionView registerClass:[ADFlowCalendarMonthHeadView class]
                    forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                           withReuseIdentifier:monthHeadViewReuseIdentifier];
    
}

#pragma mark - Prev/Next Month

- (NSDateComponents *)prevMonthDateComponents;
{
    return nil;
}

- (NSDateComponents *)nextMonthDateComponents;
{
    return nil;
}

#pragma mark - Calculate

- (void)generateCacheSectionData{
    _monthSectionData = [self monthSectionDataWithYearMonthComponents:self.yearMonthDateComponents paddingType:self.paddingType calendar:self.calendar today:self.today];
    self.isDataDirty = NO;
}

- (ADFlowCalendarSectionData *)monthSectionDataWithYearMonthComponents:(NSDateComponents *)yearMonthComponents
                                                           paddingType:(ADMonthModeFlowCalendarPaddingType)paddingType
                                                              calendar:(NSCalendar *)calendar
                                                                 today:(NSDate *)today
{
    if (calendar == nil || yearMonthComponents == nil) {
        return nil;
    }
    
    ADFlowCalendarSectionData *sectionData = [ADFlowCalendarSectionData new];
    sectionData.calendar = calendar;
    sectionData.today = today;
    
    NSDateComponents *startDateComponents = [NSDateComponents new];
    startDateComponents.era = yearMonthComponents.era;
    startDateComponents.year = yearMonthComponents.year;
    startDateComponents.month = yearMonthComponents.month;
    startDateComponents.day = 1;
    
    NSDate *sectionStartDate = [self dateOfYMDComponents:startDateComponents calendar:calendar];
    
    
    NSDate *monthLastDay = [calendar lastDayOfCalendarUnit:NSCalendarUnitMonth withDate:sectionStartDate];
    NSDateComponents *monthLastDayComponents = [self dateComponentsYMDOfDate:monthLastDay calendar:calendar];
    

    //===================
    
    sectionData.startDateComponents = startDateComponents;
    sectionData.endDateComponents = monthLastDayComponents;
    
    switch (paddingType) {
        case ADMonthModeFlowCalendarPaddingNone:
        {
            sectionData.paddedStartDateComponents = nil;
            
            
        }
            break;
        case ADMonthModeFlowCalendarPaddingWeek:
        {
            
            NSDate *firstDayOfweek = [calendar firstWeekdayWithDate:sectionStartDate];
            sectionData.paddedStartDateComponents = [self dateComponentsYMDOfDate:firstDayOfweek calendar:calendar];
            
            NSDate *lastDayOfWeek = [calendar lastWeekdayWithDate:monthLastDay];
            sectionData.paddedEndDateComponents = [self dateComponentsYMDOfDate:lastDayOfWeek calendar:calendar];
            
        }
            break;
        case ADMonthModeFlowCalendarPaddingMonth:
        {
            
        }
        case ADMonthModeFlowCalendarPaddingSixWeeks:
        {
            
            
            NSDate *firstDayOfweek = [calendar firstWeekdayWithDate:sectionStartDate];
            sectionData.paddedStartDateComponents = [self dateComponentsYMDOfDate:firstDayOfweek calendar:calendar];
            
            NSDate *lastDayOfWeek = [calendar lastWeekdayWithDate:monthLastDay];
            sectionData.paddedEndDateComponents = [self dateComponentsYMDOfDate:lastDayOfWeek calendar:calendar];
            
            NSInteger totalDays = [calendar components:NSCalendarUnitDay fromDate:firstDayOfweek toDate:lastDayOfWeek options:0].day + 1;
            NSAssert(totalDays%7 == 0, @"count of total days must be multiple of 7");
            
            NSInteger numberOfWeek = totalDays/7;
            if (numberOfWeek < 6) {
                
                sectionData.paddedEndDateComponents.day += (6 - numberOfWeek)*7;
                
            }
            
        }
            break;
        default:
            break;
    }
    
    
    
    
    
    return sectionData;
}

- (NSDateComponents *)dateComponentsYMDOfDate:(NSDate *)date calendar:(NSCalendar *)calendar
{
    NSDateComponents *components = [calendar components:ADCalendarYMDComponentUnitFlag fromDate:date];
    return components;
}

- (NSDate *)dateOfYMDComponents:(NSDateComponents *)dateComponents calendar:(NSCalendar *)calendar
{
    NSDate *date = [calendar dateFromComponents:dateComponents];
    return date;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSAssert(0, @"should never reach here");
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSAssert(0, @"should never reach here");
    return nil;
}

#pragma mark - ADFlowCalendarViewDataSource

- (NSArray *)sectionDatasInFlowCalendarView:(ADFlowCalendarView *)flowCalendarView;
{
    return [NSArray arrayWithObject:[self cachedSectionData]];
}

- (ADFlowCalendarSectionData *)flowCalendarView:(ADFlowCalendarView *)flowCalendarView flowCalendarSectionDataInSection:(NSInteger)section;
{
    return [self cachedSectionData];
}

- (NSInteger)flowCalendarView:(ADFlowCalendarView *)flowCalendarView numberOfItemsInSection:(NSInteger)section flowCalendarSectionData:(ADFlowCalendarSectionData *)sectionData;
{
    
    NSUInteger numberOfWeeks = [sectionData numberOfWeeks];
    
    return numberOfWeeks*[self.calendar adflow_daysInWeek];
}

- (ADFlowCalendarDayCell *)flowCalendarView:(ADFlowCalendarView *)flowCalendarView dayCellAtIndexPath:(NSIndexPath *)indexPath flowCalendarSectionData:(ADFlowCalendarSectionData *)sectionData{
    
    ADFlowCalendarDayCell *cell = [flowCalendarView.collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    UIEdgeInsets contentInsets = [flowCalendarView.collectionViewLayout contentInsetsForDayViewAtIndexPath:indexPath];
    cell.contentInsets = contentInsets;
    
    ADFlowCalendarDayModel *dayModel = [sectionData dayModelAtIndex:indexPath.item];
    cell.dayLabel.text = [NSString stringWithFormat:@"%@",@(dayModel.fullDateComponents.day)];
    
    cell.weekday = dayModel.fullDateComponents.weekday;
    
    cell.paddingType = dayModel.paddingType;
    cell.dayRelation = dayModel.dayRelationToToday;
    
    NSDate *currentCellDate = dayModel.date;
    BOOL isToday = [self.calendar adflow_isDate:currentCellDate inSameDayAsDate:self.today];
    if (isToday) {
        cell.dayRelation = ADFlowCalendarDayRelationToday;
    }else{
        BOOL isPast = [self.calendar adflow_isDate:currentCellDate pastDayToDate:self.today];
        if (isPast) {
            cell.dayRelation = ADFlowCalendarDayRelationPast;
        }else{
            cell.dayRelation = ADFlowCalendarDayRelationFuture;
        }
    }
    
    return cell;
    
}

- (ADFlowCalendarMonthHeadView *)flowCalendarView:(ADFlowCalendarView *)flowCalendarView monthHeadViewForSectionData:(ADFlowCalendarSectionData *)sectionData;
{
    return nil;
}

- (ADFlowCalendarSectionData *)cachedSectionData{
    if (self.isDataDirty) {
        [self generateCacheSectionData];
    }
    return self.monthSectionData;
}


#pragma mark -

- (NSString *)currentMonthTitle{
    NSString *monthTitle = [self monthTitleForSectionData:self.monthSectionData];
    return monthTitle;
}

- (NSString *)monthTitleForSectionData:(ADFlowCalendarSectionData *)sectionData{
    NSDateComponents *monthComponents = [sectionData monthComponents];
    NSString *title = [NSString stringWithFormat:@"%@年%@月",@(monthComponents.year),@(monthComponents.month)];
    return title;
}


#pragma mark - Property

- (void)setYearMonthDateComponents:(NSDateComponents *)yearMonthDateComponents{
    _yearMonthDateComponents = yearMonthDateComponents;
    self.isDataDirty = YES;
}

@end
