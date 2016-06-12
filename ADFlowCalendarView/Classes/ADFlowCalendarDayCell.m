//
//  ADFlowCalendarDayCell.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/20.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADFlowCalendarDayCell.h"

#define kDayLabelCenterY 20.0f

@implementation ADFlowCalendarDayCell

- (void)dealloc{
    
    [_dayLabel removeObserver:self forKeyPath:@"text"];
    [self removeObserver:self forKeyPath:@"dayRelation"];
    [self removeObserver:self forKeyPath:@"weekday"];
    [self removeObserver:self forKeyPath:@"paddingType"];
    [self removeObserver:self forKeyPath:@"highlighted"];
    [self removeObserver:self forKeyPath:@"selected"];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
    _dayRelation = ADFlowCalendarDayRelationDefault;
    _paddingType = ADFlowCalendarDateTypeValid;
    
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _dayLabel.font = [UIFont systemFontOfSize:15];
    _dayLabel.numberOfLines = 1;
    _dayLabel.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:_dayLabel];
    
    
    [_dayLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"dayRelation" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"weekday" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"paddingType" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
    
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (object == self.dayLabel) {
        if ([keyPath isEqualToString:@"text"]) {
            [self setNeedsLayout];
        }
    }else if (object == self) {
        
        [self updateViews];
    }
    
}

#pragma mark - Reuse

- (void)prepareForReuse{
    [super prepareForReuse];
    
    self.dayLabel.text = nil;
    
}

#pragma mark - Update UI for state

- (void)updateViews{
    
    UIFont *dayLabelFont = self.dayLabelFont;
    UIColor *dayLabelColor = self.dayLabelColor;
    UIColor *backgroundColor = self.backgroundColor;
    UIColor *selectedBackgroundColor = self.selectedBackgroundColor;
    
    if (self.isWeekend) {
        dayLabelColor = self.weekendLabelColor;
        backgroundColor = self.weekendBackgroundColor;
    }
    
    if (self.isToday) {
        
        self.dayLabel.font = self.todayLabelFont;
        
        dayLabelColor = self.todayLabelColor;
        backgroundColor = self.todayBackgroundColor;
        
    }else if (self.isFutureDay) {
        dayLabelColor = self.futureDayColor;
        backgroundColor = self.futureDayColor;
    } else {
        dayLabelColor = self.pastDayColor;
        backgroundColor = self.pastBackgroundColor;
    }
    
    if (self.isPaddingDay) {
        dayLabelColor = self.paddingDayLabelColor;
        backgroundColor = self.paddingDayBackgroundColor;
    }
    
    if (self.highlighted) {
        dayLabelColor = self.highlightedDayLabelColor;
        backgroundColor = self.highlightedBackgroundColor;
    }
    
    if (self.selected) {
        dayLabelColor = self.selectedDayLabelColor;
        backgroundColor = self.selectedBackgroundColor;
        
    }
    
    _dayLabel.font = dayLabelFont;
    _dayLabel.textColor = dayLabelColor;
    self.backgroundView.backgroundColor = backgroundColor;
    self.selectedBackgroundView.backgroundColor = selectedBackgroundColor;
    
    if ([self isGhostDay]) {
        _dayLabel.hidden = YES;
    }else{
        _dayLabel.hidden = NO;
        
        
    }
}

#pragma mark - Layout

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect realContentFrame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
    
    self.contentView.frame = realContentFrame;
    if (self.backgroundView) {
        self.backgroundView.frame = realContentFrame;
    }
    if (self.selectedBackgroundView) {
        self.selectedBackgroundView.frame = realContentFrame;
    }
    
    CGFloat centerX = floor(CGRectGetMidX(self.contentView.bounds));
    
    CGSize labelFitSize = [_dayLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.contentView.bounds), CGFLOAT_MAX)];
    
    _dayLabel.center = CGPointMake(centerX, kDayLabelCenterY);
    _dayLabel.bounds = CGRectIntegral( CGRectMake(0, 0, labelFitSize.width, labelFitSize.height));
    
    
}

#pragma mark - Property

- (BOOL)isWeekend{
    return self.weekday == 1 || self.weekday == 7;
}

- (BOOL)isPastDay{
    return _dayRelation == ADFlowCalendarDayRelationPast;
}

- (BOOL)isToday{
    return _dayRelation == ADFlowCalendarDayRelationToday;
}

- (BOOL)isFutureDay{
    return _dayRelation == ADFlowCalendarDayRelationFuture;
}

- (BOOL)isPaddingDay{
    return self.paddingType == ADFlowCalendarDateTypePadding;
}

- (BOOL)isGhostDay{
    return self.paddingType == ADFlowCalendarDateTypeGhost;
}

@end
