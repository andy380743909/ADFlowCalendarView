//
//  ADFlowCalendarDayCell.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/20.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADFlowCalendarDefine.h"


@interface ADFlowCalendarDayCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *dayLabel;

@property (nonatomic, assign) ADFlowCalendarDayRelation dayRelation;

@property (nonatomic, assign, getter=isPastDay, readonly) BOOL pastDay;
@property (nonatomic, assign, getter=isToday, readonly) BOOL today;
@property (nonatomic, assign, getter=isFutureDay, readonly) BOOL futureDay;

@property (nonatomic, assign) NSInteger weekday;

@property (nonatomic, assign, getter=isWeekend, readonly) BOOL weekend;


@property (nonatomic, assign) ADFlowCalendarDatePaddingType paddingType;
// paddingDay 和 ghostDay 是互斥状态
@property (nonatomic, assign, getter=isPaddingDay, readonly) BOOL paddingDay; // 会显示出来，但是不能操作
@property (nonatomic, assign, getter=isGhostDay, readonly) BOOL ghostDay; // 不显示，只占位置（collectionView布局，有了这个占位后，布局就简单很多）

// UI

@property (nonatomic, strong) UIFont *dayLabelFont;
@property (nonatomic, strong) UIColor *dayLabelColor;


@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIColor *pastDayColor;
@property (nonatomic, strong) UIColor *pastBackgroundColor;

@property (nonatomic, strong) UIFont *todayLabelFont;
@property (nonatomic, strong) UIColor *todayLabelColor;
@property (nonatomic, strong) UIColor *todayBackgroundColor;

@property (nonatomic, strong) UIColor *futureDayColor;

//@property (nonatomic, strong) UIFont *weekendLabelFont;
@property (nonatomic, strong) UIColor *weekendLabelColor;
@property (nonatomic, strong) UIColor *weekendBackgroundColor;


@property (nonatomic, strong) UIFont *paddingDayLabelFont;
@property (nonatomic, strong) UIColor *paddingDayLabelColor;
@property (nonatomic, strong) UIColor *paddingDayBackgroundColor;

@property (nonatomic, strong) UIColor *highlightedDayLabelColor;
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;

@property (nonatomic, strong) UIColor *selectedDayLabelColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;

@property (nonatomic, assign) UIEdgeInsets contentInsets;


// this method will be called in initWithFrame:,subclass can override this
// method to do customize initializing. must call super if override.

- (void)commonInit;

// override point. when state changed or UI style changed
- (void)updateViews;


@end