//
//  ADFlowCalendarMonthHeadView.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/21.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADFlowCalendarMonthHeadView.h"

@implementation ADFlowCalendarMonthHeadView

- (void)dealloc{
    
    [_monthTitleLabel removeObserver:self forKeyPath:@"text"];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
    _monthTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _monthTitleLabel.font = [UIFont systemFontOfSize:15];
    _monthTitleLabel.numberOfLines = 1;
    _monthTitleLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_monthTitleLabel];
    
    [_monthTitleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (object == self.monthTitleLabel) {
        if ([keyPath isEqualToString:@"text"]) {
            [self setNeedsLayout];
        }
    }
    
}

#pragma mark - Layout

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);
    
    CGSize labelFitSize = [_monthTitleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX)];
    
    _monthTitleLabel.center = CGPointMake(centerX, centerY);
    _monthTitleLabel.bounds = CGRectIntegral( CGRectMake(0, 0, labelFitSize.width, labelFitSize.height));
    
    
}

@end
