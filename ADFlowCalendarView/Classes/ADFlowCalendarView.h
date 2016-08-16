//
//  ADFlowCalendarView.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/19.
//  Copyright © 2016年 崔盼军. All rights reserved.
//
#import "ADFlowCalendarViewDataSource.h"
#import "ADFlowCalendarViewDelegate.h"
@class ADFlowCalendarCollectionViewLayout;
@class ADFlowCalendarCollectionView;
@class ADFlowCalendarWeekdaySymbolsHeadView;
@class ADFlowCalendarDayModel;
@class ADFlowCalendarSectionData;





NS_ASSUME_NONNULL_BEGIN

//typedef NS_ENUM(NSInteger, ADFlowCalendarViewDisplayMode) {
//    ADFlowCalendarViewDisplayModeWeek,
//    ADFlowCalendarViewDisplayModeMonth,
//    ADFlowCalendarViewDisplayModeYear
//};

@interface ADFlowCalendarView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>

// 使用copy，赋值后外部对calender的修改没有任何作用
@property (nonatomic, copy, readwrite) NSCalendar *calendar;

@property (nonatomic, weak, nullable) id<ADFlowCalendarViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id<ADFlowCalendarViewDelegate> delegate;

// 固定在顶端显示的“周六、周一、周二...周日”头部
@property (nonatomic, strong, nullable) ADFlowCalendarWeekdaySymbolsHeadView *weekdaySymbolHeadView;

@property (nonatomic, strong, readonly, nonnull) ADFlowCalendarCollectionView *collectionView;
@property (nonatomic, strong, nonnull) ADFlowCalendarCollectionViewLayout *collectionViewLayout;

@property (nonatomic, strong) UIColor *separatorLineColor;

- (nonnull Class<NSObject>)collectionViewClass;


- (void)reloadData;


//- (void)setWeekdaySymbolHeadViewHidden:(BOOL)hidden animated:(BOOL)animated;

@end


@interface ADFlowCalendarView (DataRetrieve)

- (ADFlowCalendarSectionData *)sectionDataAtSection:(NSInteger)section;
- (ADFlowCalendarDayModel *)dayModelAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END