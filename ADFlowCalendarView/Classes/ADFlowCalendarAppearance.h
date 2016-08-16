//
//  ADFlowCalendarAppearance.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/20.
//  Copyright © 2016年 崔盼军. All rights reserved.
//


/**
 *  TODO
 */

@interface ADFlowCalendarAppearance : NSObject

@property (nonatomic, assign) UIEdgeInsets contentInsets; // (0, 15, 0, 15)
@property (nonatomic, assign) CGFloat dayPadding; // 1.5

@property (nonatomic, assign) CGFloat weekdaySymbolHeaderViewHeight; // default is 30
@property (nonatomic, assign) CGFloat dayViewHeight; // default is 48
@property (nonatomic, assign) CGFloat dayViewDayLabelHeight; // default is 24,
@property (nonatomic, assign) CGSize dayViewDayLabelAdjustOffset; // default is (0,0)

@property (nonatomic, strong) UIColor *weekdaySymbolColor;

@property (nonatomic, strong) UIFont *weekdaySymbolFont;
@property (nonatomic, strong) UIFont *weekdayFont;
@property (nonatomic, strong) UIFont *eventFont;

@property (nonatomic, strong) UIColor *textColor;    // 工作日 文本颜色
@property (nonatomic, strong) UIColor *eventTextColor;    // 工作日 事件文本颜色
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIColor *weekendTextColor;    // 周末 文本颜色
@property (nonatomic, strong) UIColor *weekendBackgroundColor;    // 周末 背景颜色

@property (nonatomic, strong) UIColor *paddingTextColor;   // 补齐日期 文本颜色
@property (nonatomic, strong) UIColor *paddingBackgroundColor;   // 补齐日期 背景颜色

@property (nonatomic, strong) UIColor *futureDayHasEventBackgroundColor;

@property (nonatomic, strong) UIColor *todayTextColor;          // 当天文本颜色
@property (nonatomic, strong) UIColor *todayBackgroundColor;    // 当天 grid 背景色

@property (nonatomic, strong) UIColor *selectedDayTextColor;        // 被点击选中了的某天 grid 背景色
@property (nonatomic, strong) UIColor *selectedDayEventTextColor;   // 被点击选中了的某天 事件文本颜色
@property (nonatomic, strong) UIColor *selectedDayBackgroundColor;  // 被点击选中了的某天 grid 背景色



@end