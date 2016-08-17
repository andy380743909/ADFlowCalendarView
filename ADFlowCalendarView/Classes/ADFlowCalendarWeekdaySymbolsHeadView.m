//
//  ADFlowCalendarWeekdaySymbolHeadView.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/20.
//  Copyright © 2016年 崔盼军. All rights reserved.
//
#import "ADFlowCalendarWeekdaySymbolsHeadView.h"

@implementation ADFlowCalendarWeekdaySymbolView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.font = [UIFont systemFontOfSize:12];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_label];
        
    }
    return self;
}

- (void)setWeekdaySymbol:(NSString *)weekdaySymbol{
    _weekdaySymbol = weekdaySymbol;
    _label.text = _weekdaySymbol;
}

//- (void)refreshAppearance{
//    UIColor *color = self.appearance.weekdaySymbolColor;
//    _label.textColor = color;
//    _label.font = self.appearance.weekdaySymbolFont;
//}

@end

@implementation ADFlowCalendarWeekdaySymbolsHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _weekdaySymbolViews = (NSMutableArray<ADFlowCalendarWeekdaySymbolView> *)[[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)setWeekdaySymbols:(NSArray *)weekdaySymbols{
    _weekdaySymbols = weekdaySymbols;
    NSUInteger needCount = self.weekdaySymbols.count;
    
    [_weekdaySymbolViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_weekdaySymbolViews removeAllObjects];
    
    for (NSUInteger i = 0; i < needCount; i++ ) {
        NSString *symbolString = [self.weekdaySymbols objectAtIndex:i];
        ADFlowCalendarWeekdaySymbolView *view = [[ADFlowCalendarWeekdaySymbolView alloc] initWithFrame:CGRectZero];
//        view.appearance = self.appearance;
        view.weekdaySymbol = symbolString;
        [self addSubview:view];
        [_weekdaySymbolViews addObject:view];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat offsetX = self.contentInsets.left;
    CGFloat totalContentWidth = CGRectGetWidth(self.bounds) - (self.contentInsets.left + self.contentInsets.right);
    
    NSUInteger weekdayCount = self.weekdaySymbols.count;
    CGFloat width = totalContentWidth/weekdayCount;
    CGFloat height = CGRectGetHeight(self.bounds);
    
    for (NSUInteger i = 0; i < weekdayCount; i++) {
        UIView *view = [self.weekdaySymbolViews objectAtIndex:i];
        view.frame = CGRectMake(width*i + offsetX, 0, width, height);
    }
    
}

- (void)refreshAppearance{
    [self.weekdaySymbolViews makeObjectsPerformSelector:@selector(refreshAppearance)];
}

@end