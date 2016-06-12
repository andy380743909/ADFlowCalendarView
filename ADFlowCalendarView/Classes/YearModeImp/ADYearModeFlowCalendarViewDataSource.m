//
//  ADYearModeFlowCalendarViewDataSource.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/21.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADYearModeFlowCalendarViewDataSource.h"

#import "ADFlowCalendarDefine.h"
#import "NSCalendar+ADFlowCalendar.h"

#import "ADFlowCalendarView.h"
#import "ADFlowCalendarMonthHeadView.h"
#import "ADFlowCalendarDayCell.h"
#import "ADFlowCalendarSectionData.h"
#import "ADFlowCalendarDayModel.h"

@interface ADYearModeFlowCalendarViewDataSource ()

@property (nonatomic, assign) BOOL isDataDirty;
@property (nonatomic, strong) NSMutableArray *sectionDataMutableArr;

- (NSMutableArray *)sectionDataArrayWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate paddingType:(ADYearModeFlowCalendarPaddingType)paddingType calendar:(NSCalendar *)calendar today:(NSDate *)today;

@end

@implementation ADYearModeFlowCalendarViewDataSource

static NSString *cellReuseIdentifier = @"ADFlowCalendarDayCell";
static NSString *monthHeadViewReuseIdentifier = @"ADFlowCalendarMonthHeadView";

- (instancetype)init{
    self = [super init];
    if (self) {
        _sectionDataMutableArr = [NSMutableArray array];
    }
    return self;
}


- (void)registerViewClassToFlowCalendar:(ADFlowCalendarView *)calendarView{
    
    [calendarView.collectionView registerClass:[ADFlowCalendarDayCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
    [calendarView.collectionView registerClass:[ADFlowCalendarMonthHeadView class]
                    forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                           withReuseIdentifier:monthHeadViewReuseIdentifier];
    
}


#pragma mark - Calculate

- (void)generateCacheSectionData{
    
    [_sectionDataMutableArr removeAllObjects];
    
    NSArray *tmpSectionArr = [self sectionDataArrayWithStartDate:self.startDate
                                                         endDate:self.endDate
                                                     paddingType:self.paddingType
                                                        calendar:self.calendar
                                                           today:self.today
                              ];
    [_sectionDataMutableArr addObjectsFromArray:tmpSectionArr];
    self.isDataDirty = NO;
}

- (NSMutableArray *)sectionDataArrayWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate paddingType:(ADYearModeFlowCalendarPaddingType)paddingType calendar:(NSCalendar *)calendar today:(NSDate *)today
{
    
    if (calendar == nil || startDate == nil || endDate == nil) {
        return nil;
    }
    
    // check startDate <= endDate
    
    if ([startDate timeIntervalSince1970] > [endDate timeIntervalSince1970]) {
        return nil;
    }
    
    // components
    
    NSDateComponents *startDateComponents = [self dateComponentsYMDOfDate:startDate calendar:calendar];
    NSDateComponents *endDateComponents = [self dateComponentsYMDOfDate:endDate calendar:calendar];
    
    NSMutableArray *sectionArray = [NSMutableArray array];
    
    // !!! 严重bug (2016-05-09 16:00:00 +0000) ==> (2016-08-06 16:00:00 +0000)通过
    // [calendar components:NSCalendarUnitMonth fromDate:startDateMonthFirstDay
    // toDate:endDateMonthFirstDay options:NSCalendarWrapComponents].month
    // 计算出来的month是2，不是3，结果导致8月份的天数没有独立显示在8月里，而是追加在7月份，
    // 这个问题太致命了......
    // 现在改成先取startDate和endDate各自所在月份的第一天，计算它们之间相差的月份就正确了^_^
#if 1
    NSDate *startDateMonthFirstDay = [calendar firstDayOfCalendarUnit:NSCalendarUnitMonth withDate:startDate];
    NSDate *endDateMonthFirstDay = [calendar firstDayOfCalendarUnit:NSCalendarUnitMonth withDate:endDate];
    NSInteger monthsCount = [calendar components:NSCalendarUnitMonth fromDate:startDateMonthFirstDay toDate:endDateMonthFirstDay options:0].month + 1;
#else
    NSInteger monthsCount = [calendar components:NSCalendarUnitMonth fromDate:startDate toDate:endDate options:0].month + 1;
#endif
    // TODO NSCalendarWrapComponents这个选项到底有什么作用，目前还不清楚，待研究
    
    for (NSInteger i = 0 ; i < monthsCount ; i++) {
        
        ADFlowCalendarSectionData *sectionData = [ADFlowCalendarSectionData new];
        sectionData.calendar = calendar;
        sectionData.today = today;
        
        if (i == 0) {
            
            sectionData.startDateComponents = startDateComponents;
            
            // padding start
            
            {
                
                switch (paddingType) {
                    case ADYearModeFlowCalendarPaddingNone:
                        break;
                    case ADYearModeFlowCalendarPaddingWeek:
                    {
                        NSDate *firstDayOfweek = [calendar firstWeekdayWithDate:startDate];
                        
                        sectionData.paddedStartDateComponents = [self dateComponentsYMDOfDate:firstDayOfweek calendar:calendar];
                    }
                        break;
                    case ADYearModeFlowCalendarPaddingMonth:
                    {
                        NSDate *firstDayOfMonth = [calendar firstDayOfCalendarUnit:NSCalendarUnitMonth withDate:startDate];
                        
                        sectionData.paddedStartDateComponents = [self dateComponentsYMDOfDate:firstDayOfMonth calendar:calendar];
                    }
                        break;
                    default:
                        break;
                }
                
            }
            
        }else{
            
            NSDateComponents *followStartComponents = [startDateComponents copy];
            followStartComponents.month += i;
            followStartComponents.day = 1;
            
            sectionData.startDateComponents = followStartComponents;
            
        }
        
        
        
        if (i == monthsCount - 1) {
            
            sectionData.endDateComponents = endDateComponents;
            
            // padding end
            
            {
                
                switch (paddingType) {
                    case ADYearModeFlowCalendarPaddingNone:
                        break;
                    case ADYearModeFlowCalendarPaddingWeek:
                    {
                        NSDate *lastDayOfweek = [calendar lastWeekdayWithDate:endDate];
                        
                        sectionData.paddedEndDateComponents = [self dateComponentsYMDOfDate:lastDayOfweek calendar:calendar];
                    }
                        break;
                    case ADYearModeFlowCalendarPaddingMonth:
                    {
                        NSDate *lastDayOfMonth = [calendar lastDayOfCalendarUnit:NSCalendarUnitMonth withDate:endDate];
                        
                        sectionData.paddedEndDateComponents = [self dateComponentsYMDOfDate:lastDayOfMonth calendar:calendar];
                    }
                        break;
                    default:
                        break;
                }
                
            }
            
        }else{
            
            NSDate *sectionStart = [self dateOfYMDComponents:sectionData.startDateComponents calendar:calendar];
            NSDate *lastDayOfMonth = [calendar lastDayOfCalendarUnit:NSCalendarUnitMonth withDate:sectionStart];
            NSDateComponents *sectionEndComponents = [self dateComponentsYMDOfDate:lastDayOfMonth calendar:calendar];
            sectionData.endDateComponents = sectionEndComponents;
            
        }
        
        [sectionArray addObject:sectionData];
    }
    
    return sectionArray;
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
    return [NSArray arrayWithArray:[self cachedSectionDataArray]];
}

- (NSInteger)flowCalendarView:(ADFlowCalendarView *)flowCalendarView numberOfItemsInSection:(NSInteger)section flowCalendarSectionData:(ADFlowCalendarSectionData *)sectionData;
{
    
    NSUInteger numberOfWeeks = [sectionData numberOfWeeksUseCalendar:self.calendar];
    
    return numberOfWeeks*[self.calendar adflow_daysInWeek];
}


- (ADFlowCalendarWeekdaySymbolsHeadView *)weekdaySymbolHeadViewOfFlowCalendarView:(ADFlowCalendarView *)flowCalendarView;
{
    CGRect bounds = flowCalendarView.bounds;
    ADFlowCalendarWeekdaySymbolsHeadView *weekdaySymbolHeadV = [[ADFlowCalendarWeekdaySymbolsHeadView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bounds), 25)];
    
    weekdaySymbolHeadV.weekdaySymbols = [self.calendar adflow_standaloneVeryShortWeekdaySymbols];
    
    return weekdaySymbolHeadV;
}

- (ADFlowCalendarDayCell *)flowCalendarView:(ADFlowCalendarView *)flowCalendarView dayCellAtIndexPath:(NSIndexPath *)indexPath flowCalendarSectionData:(ADFlowCalendarSectionData *)sectionData
{
    
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

- (ADFlowCalendarSectionData *)flowCalendarView:(ADFlowCalendarView *)flowCalendarView flowCalendarSectionDataInSection:(NSInteger)section
{
    ADFlowCalendarSectionData *sectionData = [self sectionDataForSection:section];
    return sectionData;
}

- (ADFlowCalendarMonthHeadView *)flowCalendarView:(ADFlowCalendarView *)flowCalendarView monthHeadViewAtIndexPath:(NSIndexPath *)indexPath flowCalendarSectionData:(ADFlowCalendarSectionData *)sectionData;
{
    
    ADFlowCalendarMonthHeadView *monthHeadView = [flowCalendarView.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:monthHeadViewReuseIdentifier forIndexPath:indexPath];
    
    monthHeadView.monthTitleLabel.text = [self monthTitleForSectionData:sectionData];
    
    return monthHeadView;
}

#pragma mark - 

- (NSArray *)cachedSectionDataArray{
    if (self.isDataDirty) {
        [self generateCacheSectionData];
    }
    return [NSArray arrayWithArray:self.sectionDataMutableArr];
}

#pragma mark - Property

- (void)setStartDate:(NSDate *)startDate{
    _startDate = startDate;
    self.isDataDirty = YES;
}

- (void)setEndDate:(NSDate *)endDate{
    _endDate = endDate;
    self.isDataDirty = YES;
}

#pragma mark -

- (ADFlowCalendarSectionData *)sectionDataForSection:(NSInteger)section{
    return [[self cachedSectionDataArray] objectAtIndex:section];
}

- (NSString *)monthTitleForSectionData:(ADFlowCalendarSectionData *)sectionData{
    NSDateComponents *monthComponents = [sectionData monthComponents];
    NSString *title = [NSString stringWithFormat:@"%@年%@月",@(monthComponents.year),@(monthComponents.month)];
    return title;
}

@end
