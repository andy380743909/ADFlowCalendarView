//
//  ADFlowCalendarCollectionViewLayout.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/20.
//  Copyright © 2016年 崔盼军. All rights reserved.
//


@interface ADFlowCalendarCollectionViewLayout : UICollectionViewFlowLayout

// left:5 right:5
@property (nonatomic, assign) UIEdgeInsets calendarViewEdgeInsets;




- (CGSize)sizeForDayViewAtIndexPath:(NSIndexPath *)indexPath;

// 为了解决DayCell 不等宽的问题，两端的cell宽度分别多出 edgeInsets.left .right
- (UIEdgeInsets)contentInsetsForDayViewAtIndexPath:(NSIndexPath *)indexPath;


- (CGSize)sizeForMonthHeadViewAtSection:(NSInteger)section;


// private 根据delegate 和 self.sectionInsets判断
//- (UIEdgeInsets)contentInsetsAtSection:(NSInteger)section;

@end