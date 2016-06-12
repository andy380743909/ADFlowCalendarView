//
//  ADFlowCalendarMonthHeadView.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/21.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADFlowCalendarMonthHeadView : UICollectionReusableView

@property (nonatomic, strong) UILabel *monthTitleLabel;

@property (nonatomic, assign) BOOL currentMonth;

@end

NS_ASSUME_NONNULL_END