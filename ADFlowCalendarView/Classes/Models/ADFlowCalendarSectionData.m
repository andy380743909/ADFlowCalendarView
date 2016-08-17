//
//  ADFlowCalendarSectionData.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/20.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADFlowCalendarDayModel.h"
#import "ADFlowCalendarSectionData.h"

#import "NSCalendar+ADFlowCalendar.h"



@interface ADFlowCalendarSectionData ()

@property (nonatomic, assign) BOOL isDataDirty;



@property (nonatomic, strong) NSMutableArray *dayModelMutableArray;

// NSArray<NSDate>
// 如果startDate和endDate在同一天的话，
// https://en.wikipedia.org/wiki/Interval_(mathematics)#Including_or_excluding_endpoints
// Note that (a, a), [a, a), and (a, a] each represents the empty set, whereas [a, a] denotes the set {a}. When a > b, all four notations are usually taken to represent the empty set
- (NSArray *)datesBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate options:(ADMathIntervalEndpointOpenState)intervalOpenState;

@end

@implementation ADFlowCalendarSectionData

- (NSString *)description{
    NSMutableString *desc = [NSMutableString string];
    [desc appendFormat:@"======\n"];
    [desc appendFormat:@"padding start\t%@\n", self.paddedStartDateComponents?[self.calendar dateFromComponents:self.paddedStartDateComponents]:@"(nil)"];
    [desc appendFormat:@"        start\t%@\n", [self.calendar dateFromComponents:self.startDateComponents]];
    [desc appendFormat:@"          end\t%@\n", [self.calendar dateFromComponents:self.endDateComponents]];
    [desc appendFormat:@"padding   end\t%@\n", self.paddedEndDateComponents?[self.calendar dateFromComponents:self.paddedEndDateComponents]:@"(nil)"];
    [desc appendFormat:@"======\n"];
    return desc;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
    _isDataDirty = YES;
    _dayModelMutableArray = [NSMutableArray array];
    
}

+ (instancetype)SectionDataWithStartDateComponents:(NSDateComponents *)startDateComponents endDateComponents:(NSDateComponents *)endDateComponents calendar:(NSCalendar *)calendar{
    return [self SectionDataWithStartDateComponents:startDateComponents
                                  endDateComponents:endDateComponents
                          paddedStartDateComponents:nil
                            paddedEndDateComponents:nil
                                           calendar:calendar];
}

+ (instancetype)SectionDataWithStartDateComponents:(NSDateComponents *)startDateComponents endDateComponents:(NSDateComponents *)endDateComponents paddedStartDateComponents:(NSDateComponents *)paddedStartDateComponents paddedEndDateComponents:(NSDateComponents *)paddedEndDateComponents calendar:(NSCalendar *)calendar;
{
    ADFlowCalendarSectionData *obj = [[self alloc] initWithStartDateComponents:startDateComponents
                                                             endDateComponents:endDateComponents
                                                     paddedStartDateComponents:paddedStartDateComponents
                                                       paddedEndDateComponents:paddedEndDateComponents
                                                                      calendar:calendar];
    return obj;
}

- (instancetype)initWithStartDateComponents:(NSDateComponents *)startDateComponents
                          endDateComponents:(NSDateComponents *)endDateComponents
                                   calendar:(nonnull NSCalendar *)calendar;
{
    return [self initWithStartDateComponents:startDateComponents
                           endDateComponents:endDateComponents
                   paddedStartDateComponents:nil
                     paddedEndDateComponents:nil
                                    calendar:calendar];
}

- (instancetype)initWithStartDateComponents:(NSDateComponents *)startDateComponents
                          endDateComponents:(NSDateComponents *)endDateComponents
                  paddedStartDateComponents:(nullable NSDateComponents *)paddedStartDateComponents
                    paddedEndDateComponents:(nullable NSDateComponents *)paddedEndDateComponents
                                   calendar:(nonnull NSCalendar *)calendar;
{
    self = [self init];
    if (self) {
        
        _startDateComponents = startDateComponents;
        _endDateComponents = endDateComponents;
        _paddedStartDateComponents = paddedStartDateComponents;
        _paddedEndDateComponents = paddedEndDateComponents;
        
        _calendar = calendar;
        
    }
    return self;
}

- (void)calculateDayArray{
    [_dayModelMutableArray removeAllObjects];
    
    NSDate *firstGhostDay = [self firstDayOfFirstWeek];
    NSDate *lastGhostDay = [self lastDayOfLastWeek];
    
    NSInteger totalDays = [self.calendar components:NSCalendarUnitDay fromDate:firstGhostDay toDate:lastGhostDay options:0].day + 1;
    if (totalDays%7 != 0) {
        NSLog(@"error....totalDays:%@,firstGhostDay:%@,lastGhostDay:%@",@(totalDays),firstGhostDay,lastGhostDay);
    }
    
    // 方案1: for 循环创建所有的日期model
//    for (NSInteger i = 0; i < totalDays ; i++) {
//        
//        
//        
//        
//    }
    
    // 方案2: 用区间计算，再拼接
    
    // 两个临时指针
    NSDate *startDateCursor = nil;
    NSDate *endDateCursor = nil;
    
    // [ghost -> paddedStart)
    {
        
        startDateCursor = [self firstDayOfFirstWeek];
        endDateCursor = [self.calendar dateFromComponents:self.paddedStartDateComponents?:self.startDateComponents];
        
        NSArray *headGhostDates = [self datesBetweenStartDate:startDateCursor endDate:endDateCursor options:ADMathIntervalHalfCloseHalfOpen];
        
        //NSLog(@"headGhostDates:\n%@",headGhostDates);
        
        NSArray *headGhostModelArr = [self dayModelsArrayFromDateArray:headGhostDates paddingType:ADFlowCalendarDateTypeGhost];
        [_dayModelMutableArray addObjectsFromArray:headGhostModelArr];
    }
    
    // [paddedStart -> start)
    
    if (self.paddedStartDateComponents) {
        
        startDateCursor = [self.calendar dateFromComponents:self.paddedStartDateComponents];
        endDateCursor = [self.calendar dateFromComponents:self.startDateComponents];
        
        NSArray *headPaddingDates = [self datesBetweenStartDate:startDateCursor endDate:endDateCursor options:ADMathIntervalHalfCloseHalfOpen];
        //NSLog(@"headPaddingDates:\n%@",headPaddingDates);
        NSArray *headPaddingModelArr = [self dayModelsArrayFromDateArray:headPaddingDates paddingType:ADFlowCalendarDateTypePadding];
        [_dayModelMutableArray addObjectsFromArray:headPaddingModelArr];
    }
    
    
    // [start -> end]
    {
        startDateCursor = [self.calendar dateFromComponents:self.startDateComponents];
        endDateCursor = [self.calendar dateFromComponents:self.endDateComponents];
        
        NSArray *validDates = [self datesBetweenStartDate:startDateCursor endDate:endDateCursor options:ADMathIntervalClose];
        //NSLog(@"validDates:\n%@",validDates);
        NSArray *validModelArr = [self dayModelsArrayFromDateArray:validDates paddingType:ADFlowCalendarDateTypeValid];
        [_dayModelMutableArray addObjectsFromArray:validModelArr];
    }
    
    // (end -> paddedEnd]
    
    if (self.paddedEndDateComponents) {
        
        startDateCursor = [self.calendar dateFromComponents:self.endDateComponents];
        endDateCursor = [self.calendar dateFromComponents:self.paddedEndDateComponents];
        
        NSArray *tailPaddingDates = [self datesBetweenStartDate:startDateCursor endDate:endDateCursor options:ADMathIntervalHalfOpenHalfClose];
        //NSLog(@"tailPaddingDates:\n%@",tailPaddingDates);
        NSArray *tailPaddingModelArr = [self dayModelsArrayFromDateArray:tailPaddingDates paddingType:ADFlowCalendarDateTypePadding];
        [_dayModelMutableArray addObjectsFromArray:tailPaddingModelArr];
    }
    
    // (paddedEnd -> ghost]
    
    {
        startDateCursor = [self.calendar dateFromComponents:self.paddedEndDateComponents?:self.endDateComponents];
        endDateCursor = [self lastDayOfLastWeek];
        
        NSArray *tailGhostDates = [self datesBetweenStartDate:startDateCursor endDate:endDateCursor options:ADMathIntervalHalfOpenHalfClose];
        //NSLog(@"tailGhostDates:\n%@",tailGhostDates);
        
        NSArray *tailGhostModelArr = [self dayModelsArrayFromDateArray:tailGhostDates paddingType:ADFlowCalendarDateTypeGhost];
        [_dayModelMutableArray addObjectsFromArray:tailGhostModelArr];
    }
    
    self.isDataDirty = NO;
}

- (NSArray *)dayModelsArrayFromDateArray:(NSArray *)dateArray paddingType:(ADFlowCalendarDatePaddingType)paddingType{
    if ([dateArray count] == 0) {
        return @[];
    }
    NSMutableArray *dayModelsArr = [NSMutableArray arrayWithCapacity:[dateArray count]];
    [dateArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = (NSDate *)obj;
        ADFlowCalendarDayModel *dayModel = [ADFlowCalendarDayModel DayModelWithDate:date calendar:self.calendar todayDate:self.today];
        dayModel.paddingType = paddingType;
        [dayModelsArr addObject:dayModel];
    }];
    return dayModelsArr;
}

#pragma mark - Query

- (ADFlowCalendarDayModel *)dayModelAtIndex:(NSInteger)index{
    return [[self cachedDayArray] objectAtIndex:index];
}

- (NSUInteger)numberOfWeeksUseCalendar:(NSCalendar *)calendar{
    
//    NSDate *fromDate = [calendar dateFromComponents:self.paddedStartDateComponents?:self.startDateComponents];
//    NSDate *toDate = [calendar dateFromComponents:self.paddedEndDateComponents?:self.endDateComponents];
//    NSUInteger numberOfWeeks = [calendar components:NSCalendarUnitWeekOfYear fromDate:fromDate toDate:toDate options:0].weekOfYear;
    
    NSUInteger numberOfWeeks = [[self dayModelMutableArray] count]/7;
    
    return numberOfWeeks;
}

- (NSUInteger)numberOfWeeks{
    NSUInteger numberOfWeeks = [[self dayModelMutableArray] count]/7;
    return numberOfWeeks;
}

#pragma mark -

- (NSArray *)cachedDayArray{
    if (self.isDataDirty) {
        [self calculateDayArray];
    }
    return [NSArray arrayWithArray:_dayModelMutableArray];
}

- (NSDate *)firstDayOfFirstWeek{
    NSDate *fromDate = [self.calendar dateFromComponents:self.paddedStartDateComponents?:self.startDateComponents];
    NSDate *result = [self.calendar firstWeekdayWithDate:fromDate];
    return result;
}

- (NSDate *)lastDayOfLastWeek{
    NSDate *toDate = [self.calendar dateFromComponents:self.paddedEndDateComponents?:self.endDateComponents];
    NSDate *result = [self.calendar lastWeekdayWithDate:toDate];
    return result;
}

- (NSDateComponents *)monthComponents{
    
    NSDateComponents *dateComponents = [self.calendar dateComponentsFullFromDate:[self.calendar dateFromComponents:self.startDateComponents]];
    
    return dateComponents;
}

- (NSDateComponents *)weekComponents{
    NSDateComponents *dateComponents = [self.calendar dateComponentsFullFromDate:[self.calendar dateFromComponents:self.startDateComponents]];
    
    return dateComponents;
}

#pragma mark - Date Helper Methods

- (NSArray *)datesBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate options:(ADMathIntervalEndpointOpenState)intervalOpenState{
    
    if (startDate == nil || endDate == nil) {
        return nil;
    }
    
    // startDate == endDate
    
    if ([self.calendar adflow_isDate:startDate inSameDayAsDate:endDate]) {
        
        if (intervalOpenState == ADMathIntervalClose) {
            return @[startDate];
        }else{
            return nil;
        }
        
    }
    
    // startDate > endDate
    
    if ([self.calendar adflow_isDate:startDate futureDayToDate:endDate]) {
        return nil;
    }
    
    // normal case
    
    NSMutableArray *daysArr = [NSMutableArray array];
    
    NSInteger dayBetween = [self.calendar components:NSCalendarUnitDay fromDate:startDate toDate:endDate options:0].day;
    NSDateComponents *oneDayStepComponents = [NSDateComponents new];
    
    
    // 为什么要用 i <= dayBetween, 因为 dayBetween(20160414 - 20160415) == 1, 不是2
    for (NSInteger i = 0; i <= dayBetween ; i++) {
        oneDayStepComponents.day = i;
        
        if (i == 0 && ((intervalOpenState & ADMathIntervalLeftClose) != ADMathIntervalLeftClose)) {
            continue;
        }
        if (i == dayBetween && ((intervalOpenState & ADMathIntervalRightClose) != ADMathIntervalRightClose)) {
            continue;
        }
        NSDate *tmpDate = [self.calendar dateByAddingComponents:oneDayStepComponents toDate:startDate options:0];
        [daysArr addObject:tmpDate];
    }
    
    return daysArr;
}

#pragma mark - Property

- (void)setToday:(NSDate *)today{
    _today = today;
    self.isDataDirty = YES;
}

- (NSArray *)dayModelMutableArray{
    return [NSArray arrayWithArray:[self cachedDayArray]];
}

@end