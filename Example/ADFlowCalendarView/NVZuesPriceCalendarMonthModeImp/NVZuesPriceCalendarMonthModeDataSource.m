//
//  NVZuesPriceCalendarDataSource.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/23.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "NVZuesPriceCalendarMonthModeDataSource.h"

#import "UIView+Border.h"
#import "NSCalendar+ADFlowCalendar.h"

#import "ADFlowCalendarView.h"
#import "ADFlowCalendarCollectionView.h"
#import "ADFlowCalendarMonthHeadView.h"
#import "NVZuesPriceCalendarDayCell.h"

#import "ADFlowCalendarDayModel.h"
#import "ADFlowCalendarSectionData.h"

static NSString *cellReuseIdentifier = @"ADFlowCalendarDayCell";
static NSString *monthHeadViewReuseIdentifier = @"ADFlowCalendarMonthHeadView";

@implementation NVZuesPriceCalendarMonthModeDataSource

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

- (void)registerViewClassToFlowCalendar:(ADFlowCalendarView *)calendarView{
    
    [calendarView.collectionView registerClass:[NVZuesPriceCalendarDayCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
    [calendarView.collectionView registerClass:[ADFlowCalendarMonthHeadView class]
                    forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                           withReuseIdentifier:monthHeadViewReuseIdentifier];
    
}

#pragma mark - data query

- (NSDictionary *)dayPriceStockInfoForDate:(NSDate *)date{
    NSString *dateString = [self.ymdDateFormatter stringFromDate:date];
    NSDictionary *dayPriceStockInfo = [self.dayPriceStockDict objectForKey:dateString];
    return dayPriceStockInfo;
}

#pragma mark DataSource

- (ADFlowCalendarDayCell *)flowCalendarView:(ADFlowCalendarView *)flowCalendarView dayCellAtIndexPath:(NSIndexPath *)indexPath flowCalendarSectionData:(ADFlowCalendarSectionData *)sectionData
{
    
    NVZuesPriceCalendarDayCell *cell = (NVZuesPriceCalendarDayCell *)[super flowCalendarView:flowCalendarView dayCellAtIndexPath:indexPath flowCalendarSectionData:sectionData];
    
    ADFlowCalendarDayModel *dayModel = [sectionData dayModelAtIndex:indexPath.item];
    
    if (dayModel.isToday) {
        cell.dayLabel.text = @"今天";
    }
    
    NSDictionary *dayInfoDict = [self dayPriceStockInfoForDate:dayModel.date];
    
    if (dayInfoDict == nil) {
        
        cell.disabled = NO;
        cell.detailLabel.text = nil;
        cell.topleftFlagImgV.hidden = YES;
        cell.topleftFlagImgV.image = nil;
        
    }else{
        NSNumber *stock = dayInfoDict[@"stock"];
        NSNumber *stockThreshold = dayInfoDict[@"stockThreshold"];
        NSNumber *priceNum = dayInfoDict[@"price"];
        NSString *priceStr = [NSString stringWithFormat:@"¥%.0f",[priceNum doubleValue]];
        
        BOOL stockWarning = [stock integerValue] <= [stockThreshold integerValue];
        BOOL soldout = [stock integerValue] <= 0;
        
        if (soldout) {
            
            cell.disabled = YES;
            cell.detailLabel.text = @"售罄";
            
        }else{
            
            cell.disabled = NO;
            cell.detailLabel.text = priceStr;
            
            // 不能在这里控制imageV的显示和隐藏，这里会覆盖isGhostDay的逻辑。
            // topleftFlagImgV.hidden取决于isGhostDay状态，而topleftFlagImgV.image取决于数据
            if (stockWarning) {
//                cell.topleftFlagImgV.hidden = NO;
                cell.topleftFlagImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"zues_stock_remain_%@",stock]];
            }else{
                cell.topleftFlagImgV.image = nil;
//                cell.topleftFlagImgV.hidden = YES;
            }
            
        }
    }
    
    // border
    
    NSDictionary *styleBottom = @{
                                  @"width":@(1),
                                  @"inset":NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0, 0, 0, 0)),
                                  @"color":flowCalendarView.separatorLineColor
                                  };
    
    [cell setBorderWithStyle:styleBottom forEdge:UIViewBorderEdgeBottom];
    
    NSDictionary *styleRight = @{
                                 @"width":@(1),
                                 @"inset":NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0, 0, 0, 0)),
                                 @"color":flowCalendarView.separatorLineColor
                                 };
    
    // 不是行尾
    if ([self.calendar adflow_indexOfWeekday:cell.weekday] != 6) {
        [cell setBorderWithStyle:styleRight forEdge:UIViewBorderEdgeRight];
    }else{
        [cell setBorderWithStyle:nil forEdge:UIViewBorderEdgeRight];
    }
    
    
    return cell;
}

- (ADFlowCalendarMonthHeadView *)flowCalendarView:(ADFlowCalendarView *)flowCalendarView monthHeadViewAtIndexPath:(NSIndexPath *)indexPath flowCalendarSectionData:(ADFlowCalendarSectionData *)sectionData;
{
    
    ADFlowCalendarMonthHeadView *monthHeadView = [flowCalendarView.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:monthHeadViewReuseIdentifier forIndexPath:indexPath];
    
    monthHeadView.monthTitleLabel.text = nil;
    monthHeadView.monthTitleLabel.textColor = [UIColor blackColor];
    
    // border
    if (indexPath.section == 0) {
        
        NSDictionary *styleTop = @{
                                   @"width":@(1),
                                   @"inset":NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0, 0, 0, 0)),
                                   @"color":flowCalendarView.separatorLineColor
                                   };
        
        [monthHeadView setBorderWithStyle:styleTop forEdge:UIViewBorderEdgeTop];
    }else{
        [monthHeadView setBorderWithStyle:nil forEdge:UIViewBorderEdgeTop];
    }
    
    NSDictionary *styleBottom = @{
                                  @"width":@(1),
                                  @"inset":NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0, 0, 0, 0)),
                                  @"color":flowCalendarView.separatorLineColor
                                  };
    
    [monthHeadView setBorderWithStyle:styleBottom forEdge:UIViewBorderEdgeBottom];
    
    monthHeadView.hidden = YES;
    return monthHeadView;
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
