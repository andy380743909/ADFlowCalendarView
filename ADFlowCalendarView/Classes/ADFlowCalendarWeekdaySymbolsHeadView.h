//
//  ADFlowCalendarWeekdaySymbolHeadView.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/20.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADFlowCalendarWeekdaySymbolView <NSObject>
@end

@interface ADFlowCalendarWeekdaySymbolView : UIView<ADFlowCalendarWeekdaySymbolView>

@property (nonatomic, assign) NSInteger weekday;
@property (nonatomic, strong) NSString *weekdaySymbol;

@property (nonatomic, strong) UILabel *label;

@end

@interface ADFlowCalendarWeekdaySymbolsHeadView : UIView

@property (nonatomic, strong) NSArray *weekdaySymbols;
@property (nonatomic, strong) NSMutableArray<ADFlowCalendarWeekdaySymbolView> *weekdaySymbolViews;

// left:5 right:5
@property (nonatomic, assign) UIEdgeInsets contentInsets;

@end
