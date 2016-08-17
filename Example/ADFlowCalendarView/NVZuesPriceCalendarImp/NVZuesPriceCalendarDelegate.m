//
//  NVZuesPriceCalendarDelegate.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/24.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "NVZuesPriceCalendarDelegate.h"

#import "ADFlowCalendarView.h"
#import "ADFlowCalendarCollectionView.h"


@implementation NVZuesPriceCalendarDelegate

- (instancetype)init{
    self = [super init];
    if (self) {
        _ymdDateFormatter = [[NSDateFormatter alloc] init];
        _ymdDateFormatter.dateFormat = @"yyyyMMdd";
        //        _ymdDateFormatter.timeZone = self.calendar.timeZone;
        //        _ymdDateFormatter.calendar = self.calendar;
        
        _dayPriceStockDict = [self MockPriceStockDict];
    }
    return self;
}

#pragma mark - data query

- (NSDictionary *)dayPriceStockInfoForDate:(NSDate *)date{
    NSString *dateString = [self.ymdDateFormatter stringFromDate:date];
    NSDictionary *dayPriceStockInfo = [self.dayPriceStockDict objectForKey:dateString];
    return dayPriceStockInfo;
}

- (BOOL)canOperateOnDayModel:(ADFlowCalendarDayModel *)dayModel{
    
    NSDictionary *dayInfoDict = [self dayPriceStockInfoForDate:dayModel.date];
    
    if (dayInfoDict == nil) {
        
        return NO;
        
    }else{
        NSNumber *stock = dayInfoDict[@"stock"];
//        NSNumber *stockThreshold = dayInfoDict[@"stockThreshold"];
//        NSNumber *priceNum = dayInfoDict[@"price"];
//        NSString *priceStr = [NSString stringWithFormat:@"¥%.0f",[priceNum doubleValue]];
        
//        BOOL stockWarning = [stock integerValue] <= [stockThreshold integerValue];
        BOOL soldout = [stock integerValue] <= 0;
        
        if (soldout) {
            
            return NO;
            
        }else{
            
            return YES;
            
        }
    }
}

#pragma mark - Delegate

- (BOOL)flowCalendarView:(ADFlowCalendarView *)flowCalendarView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath dayModel:(ADFlowCalendarDayModel *)dayModel;
{
    
    BOOL shouldHighlight = [super flowCalendarView:flowCalendarView shouldHighlightItemAtIndexPath:indexPath dayModel:dayModel];
    
    if (!shouldHighlight) {
        return NO;
    }
    
    shouldHighlight = [self canOperateOnDayModel:dayModel];
    
    return shouldHighlight;
}


- (BOOL)flowCalendarView:(ADFlowCalendarView *)flowCalendarView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath dayModel:(ADFlowCalendarDayModel *)dayModel;
{
    BOOL shouldSelect = [super flowCalendarView:flowCalendarView shouldHighlightItemAtIndexPath:indexPath dayModel:dayModel];
    
    if (!shouldSelect) {
        return NO;
    }
    
    shouldSelect = [self canOperateOnDayModel:dayModel];
    
    return shouldSelect;
}

- (void)flowCalendarView:(ADFlowCalendarView *)flowCalendarView didSelectItemAtIndexPath:(NSIndexPath *)indexPath dayModel:(ADFlowCalendarDayModel *)dayModel{
    
    [flowCalendarView.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Mock Data

- (NSDictionary *)MockPriceStockDict{
    
    return @{
             @"20160401":@{
                     @"stock":@(1),
                     @"stockThreshold":@(4),
                     @"price":@(308)
                     },
             @"20160402":@{
                     @"stock":@(2),
                     @"stockThreshold":@(4),
                     @"price":@(308)
                     },
             @"20160403":@{
                     @"stock":@(3),
                     @"stockThreshold":@(4),
                     @"price":@(308)
                     },
             @"20160404":@{
                     @"stock":@(4),
                     @"stockThreshold":@(4),
                     @"price":@(308)
                     },
             @"20160405":@{
                     @"stock":@(5),
                     @"stockThreshold":@(4),
                     @"price":@(308)
                     },
             @"20160406":@{
                     @"stock":@(6),
                     @"stockThreshold":@(4),
                     @"price":@(308)
                     },
             @"20160407":@{
                     @"stock":@(7),
                     @"stockThreshold":@(4),
                     @"price":@(308)
                     },
             @"20160408":@{
                     @"stock":@(8),
                     @"stockThreshold":@(4),
                     @"price":@(308)
                     },
             @"20160409":@{
                     @"stock":@(9),
                     @"stockThreshold":@(4),
                     @"price":@(308)
                     },
             @"20160410":@{
                     @"stock":@(0),
                     @"stockThreshold":@(4),
                     @"price":@(308)
                     },
             @"20160411":@{
                     @"stock":@(4),
                     @"stockThreshold":@(4),
                     @"price":@(100)
                     },
             @"20160412":@{
                     @"stock":@(4),
                     @"stockThreshold":@(4),
                     @"price":@(101)
                     },
             @"20160413":@{
                     @"stock":@(4),
                     @"stockThreshold":@(4),
                     @"price":@(102)
                     },
             @"20160414":@{
                     @"stock":@(4),
                     @"stockThreshold":@(4),
                     @"price":@(103)
                     },
             @"20160501":@{
                     @"stock":@(4),
                     @"stockThreshold":@(4),
                     @"price":@(103)
                     },
             @"20160502":@{
                     @"stock":@(4),
                     @"stockThreshold":@(4),
                     @"price":@(103)
                     },
             @"20160503":@{
                     @"stock":@(4),
                     @"stockThreshold":@(4),
                     @"price":@(103)
                     },
             @"20160504":@{
                     @"stock":@(4),
                     @"stockThreshold":@(4),
                     @"price":@(103)
                     },
             @"20160505":@{
                     @"stock":@(4),
                     @"stockThreshold":@(4),
                     @"price":@(103)
                     },
             @"20160506":@{
                     @"stock":@(4),
                     @"stockThreshold":@(4),
                     @"price":@(103)
                     },
             @"20160507":@{
                     @"stock":@(4),
                     @"stockThreshold":@(4),
                     @"price":@(103)
                     },
             @"20160508":@{
                     @"stock":@(4),
                     @"stockThreshold":@(4),
                     @"price":@(103)
                     }
             };
    
}


@end
