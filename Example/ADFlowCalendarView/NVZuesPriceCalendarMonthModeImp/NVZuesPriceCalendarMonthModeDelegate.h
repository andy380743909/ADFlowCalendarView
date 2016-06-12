//
//  NVZuesPriceCalendarDelegate.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/24.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADMonthModeFlowCalendarViewDelegate.h"

@interface NVZuesPriceCalendarMonthModeDelegate : ADMonthModeFlowCalendarViewDelegate

@property (nonatomic, strong) NSDateFormatter *ymdDateFormatter;

@property (nonatomic, strong) NSArray *dayPriceStockArr;

// key: date value:dict
@property (nonatomic, strong) NSDictionary *dayPriceStockDict;

@end
