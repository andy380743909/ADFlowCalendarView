//
//  NVZuesPriceCalendarDayCell.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/23.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADFlowCalendarDayCell.h"

@interface NVZuesPriceCalendarMonthModeDayCell : ADFlowCalendarDayCell

@property (nonatomic, strong) UIImageView *topleftFlagImgV;

// 显示价格 或 “售罄”
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIColor *detailLabelColor;

@property (nonatomic, strong) UIColor *highlightedDetailLabelColor;
@property (nonatomic, strong) UIColor *selectedDetailLabelColor;

@property (nonatomic, strong) UIColor *disabledDayLabelColor;
@property (nonatomic, strong) UIColor *disabledDetailLabelColor;
@property (nonatomic, strong) UIColor *disabledBackgroundColor;

@property (nonatomic, assign) BOOL disabled;




@end
