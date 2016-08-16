//
//  NVZuesPriceCalendarDataSource.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/23.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADWeekModeFlowCalendarViewDataSource.h"


@interface NVZuesPriceCalendarWeekModeDataSource : ADWeekModeFlowCalendarViewDataSource

@property (nonatomic, strong) NSDateFormatter *ymdDateFormatter;

@property (nonatomic, strong) NSArray *dayPriceStockArr;

// key: date value:dict
@property (nonatomic, strong) NSDictionary *dayPriceStockDict;

@end
