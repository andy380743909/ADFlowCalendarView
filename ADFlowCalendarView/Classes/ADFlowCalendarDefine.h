//
//  ADFlowCalendarDefine.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/20.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#ifndef ADFlowCalendarDefine_h
#define ADFlowCalendarDefine_h

typedef NS_ENUM(NSInteger, ADFlowCalendarDayRelation) {
    ADFlowCalendarDayRelationPast       = -1,
    ADFlowCalendarDayRelationFuture     = 1,
    ADFlowCalendarDayRelationToday      = 0,
    ADFlowCalendarDayRelationDefault    = ADFlowCalendarDayRelationPast
};

typedef NS_ENUM(NSInteger, ADFlowCalendarDatePaddingType) {
    ADFlowCalendarDateTypeOutOfRange    = -3,
    ADFlowCalendarDateTypeGhost         = -2,
    ADFlowCalendarDateTypePadding       = -1,
    ADFlowCalendarDateTypeValid         = 0
};

// 区间开闭状态 开区间、比区间、半开半闭、半闭半开
typedef NS_OPTIONS(NSInteger, ADMathIntervalEndpointOpenState) {
    ADMathIntervalLeftClose = 1UL << 1,
    ADMathIntervalRightClose = 1UL << 0,
    ADMathIntervalClose = ADMathIntervalLeftClose | ADMathIntervalRightClose,
    ADMathIntervalOpen = 0,
    ADMathIntervalHalfCloseHalfOpen = ADMathIntervalLeftClose,
    ADMathIntervalHalfOpenHalfClose = ADMathIntervalRightClose
};

#define ADCalendarYMDComponentUnitFlag (NSCalendarUnitEra |NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)


#endif /* ADFlowCalendarDefine_h */
