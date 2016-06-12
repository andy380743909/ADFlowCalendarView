//
//  ADMonthModeFlowCalendarViewDataSource.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/21.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADWeekModeFlowCalendarViewDataSource.h"

#import "ADFlowCalendarDefine.h"
#import "NSCalendar+ADFlowCalendar.h"

#import "ADFlowCalendarView.h"
#import "ADFlowCalendarMonthHeadView.h"
#import "ADFlowCalendarDayCell.h"
#import "ADFlowCalendarSectionData.h"
#import "ADFlowCalendarDayModel.h"

@interface ADWeekModeFlowCalendarViewDataSource ()

@property (nonatomic, assign) BOOL isDataDirty;
@property (nonatomic, strong) ADFlowCalendarSectionData *weeksSectionData;

@end

@implementation ADWeekModeFlowCalendarViewDataSource

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

- (NSString *)weekdaySymbolForWeekday:(NSUInteger)weekday{
    if (weekday < 1 || weekday > 7) {
        return nil;
    }
    NSArray *weekdaySymbols = [self.calendar veryShortStandaloneWeekdaySymbols];
    NSInteger index = weekday - 1;
    NSString *symbol = [weekdaySymbols objectAtIndex:index];
    return symbol;
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
    
    self.weeksSectionData = [self sectionDataWithStartDate:self.startDate
                                                   endDate:self.endDate
                                               paddingType:self.paddingType
                                                  calendar:self.calendar
                                                     today:self.today];
    self.isDataDirty = NO;
}

- (ADFlowCalendarSectionData *)sectionDataWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate paddingType:(ADWeekModeFlowCalendarPaddingType)paddingType calendar:(NSCalendar *)calendar today:(NSDate *)today
{
    
    if (calendar == nil || startDate == nil || endDate == nil) {
        return nil;
    }
    
    // check startDate <= endDate
    
    if ([startDate timeIntervalSince1970] > [endDate timeIntervalSince1970]) {
        return nil;
    }
    
    ADFlowCalendarSectionData *sectionData = [ADFlowCalendarSectionData new];
    sectionData.calendar = calendar;
    sectionData.today = today;
    
    // components
    
    NSDateComponents *startDateComponents = [self dateComponentsYMDOfDate:startDate calendar:calendar];
    NSDateComponents *endDateComponents = [self dateComponentsYMDOfDate:endDate calendar:calendar];
    
    sectionData.startDateComponents = startDateComponents;
    sectionData.endDateComponents = endDateComponents;
    
    
    switch (paddingType) {
        case ADWeekModeFlowCalendarPaddingNone:
            
            break;
        case ADWeekModeFlowCalendarPaddingWeek:
        {
            NSDate *firstDayOfweek = [calendar firstWeekdayWithDate:startDate];
            sectionData.paddedStartDateComponents = [self dateComponentsYMDOfDate:firstDayOfweek calendar:calendar];
            
            NSDate *lastDayOfweek = [calendar lastWeekdayWithDate:endDate];
            sectionData.paddedEndDateComponents = [self dateComponentsYMDOfDate:lastDayOfweek calendar:calendar];
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
    return self.weeksSectionData;
}


#pragma mark -



#pragma mark - Property

- (void)setStartDate:(NSDate *)startDate{
    _startDate = startDate;
    self.isDataDirty = YES;
}

- (void)setEndDate:(NSDate *)endDate{
    _endDate = endDate;
    self.isDataDirty = YES;
}

@end
