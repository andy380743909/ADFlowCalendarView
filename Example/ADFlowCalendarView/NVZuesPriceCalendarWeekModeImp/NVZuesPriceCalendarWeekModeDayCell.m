//
//  NVZuesPriceCalendarDayCell.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/23.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "NVZuesPriceCalendarWeekModeDayCell.h"

@implementation NVZuesPriceCalendarWeekModeDayCell

- (void)dealloc{
    
    [_detailLabel removeObserver:self forKeyPath:@"text"];
    [self removeObserver:self forKeyPath:@"disabled"];
    
}

- (void)commonInit{
    [super commonInit];
    
    [self configUIStyleSettings];
    
    [self setupSubViews];
    
}

- (void)configUIStyleSettings{
    
    self.dayLabelFont = [UIFont systemFontOfSize:15];
    self.dayLabelColor = [UIColor blackColor];
    
    
    
    
    self.backgroundColor = [UIColor clearColor];
    
    self.pastDayColor = [UIColor grayColor];
    
    self.todayLabelFont = [UIFont systemFontOfSize:15];
    self.todayLabelColor = [UIColor redColor];
    self.todayBackgroundColor = [UIColor clearColor];
    
    self.futureDayColor = [UIColor blackColor];
    
    //self.weekendLabelFont;
    self.weekendLabelColor = [UIColor colorWithRed:0xff/255.0f green:0x7e/255.0f blue:0x6d/255.0f alpha:1.0f];
    self.weekendBackgroundColor = [UIColor clearColor];
    
    
    self.paddingDayLabelFont = [UIFont systemFontOfSize:15];
    self.paddingDayLabelColor = [UIColor colorWithRed:0xcc/255.0f green:0xcc/255.0f blue:0xcc/255.0f alpha:1.0f];
    self.paddingDayBackgroundColor = [UIColor clearColor];
    
    self.highlightedDayLabelColor = [UIColor whiteColor];
    self.highlightedBackgroundColor = [UIColor orangeColor];
    
    self.selectedDayLabelColor = [UIColor whiteColor];
    self.selectedBackgroundColor = [UIColor orangeColor];
    
    self.detailLabelColor = [UIColor colorWithRed:0xff/255.0f green:0x66/255.0f blue:0x33/255.0f alpha:1.0f];
    self.highlightedDetailLabelColor = [UIColor whiteColor];
    self.selectedDetailLabelColor = [UIColor whiteColor];
    
    self.disabledDayLabelColor = [UIColor colorWithRed:181/255.0f green:181/255.0f blue:181/255.0f alpha:1.0f];
    self.disabledDetailLabelColor = [UIColor colorWithRed:181/255.0f green:181/255.0f blue:181/255.0f alpha:1.0f];
    self.disabledBackgroundColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f];
    
}

- (void)setupSubViews{
    
    _weekdayLabel = [UILabel new];
    _weekdayLabel.numberOfLines = 1;
    _weekdayLabel.backgroundColor = [UIColor clearColor];
    _weekdayLabel.font = [UIFont systemFontOfSize:9];
    _weekdayLabel.textColor = [UIColor colorWithRed:0xcc/255.0f green:0xcc/255.0f blue:0xcc/255.0f alpha:1.0f];
    [self.contentView addSubview:_weekdayLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _detailLabel.numberOfLines = 1;
    _detailLabel.adjustsFontSizeToFitWidth = YES;
    _detailLabel.font = [UIFont systemFontOfSize:10];
    _detailLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_detailLabel];
    
    _topleftFlagImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.contentView addSubview:_topleftFlagImgV];
    
    // KVO
    
    [_detailLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    [_weekdayLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"disabled" options:NSKeyValueObservingOptionNew context:NULL];
    
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (object == self.detailLabel) {
        if ([keyPath isEqualToString:@"text"]) {
            [self setNeedsLayout];
        }
    }else if (object == self.weekdayLabel) {
        if ([keyPath isEqualToString:@"text"]) {
            [self.weekdayLabel sizeToFit];
            [self setNeedsLayout];
        }
    }else if (object == self) {
        
        [self updateViews];
    }
    
}

#pragma mark - Reuse

- (void)prepareForReuse{
    [super prepareForReuse];
    
    self.disabled = NO;
    self.weekdayLabel.text = nil;
    self.detailLabel.text = nil;
    self.topleftFlagImgV.hidden = YES;
    self.topleftFlagImgV.image = nil;
    
}

#pragma mark - Update UI for state

- (void)updateViews{
    [super updateViews];
    
    _weekdayLabel.hidden = self.isGhostDay;
    _detailLabel.hidden = self.isGhostDay;
    _topleftFlagImgV.hidden = self.isGhostDay;
    
    UIColor *detailLabelColor = self.detailLabelColor;
    
    if (!self.disabled) {
        
        self.backgroundView.backgroundColor = self.backgroundColor;
    }else{
        
        detailLabelColor = self.disabledDetailLabelColor;
        self.backgroundView.backgroundColor = self.disabledBackgroundColor;
    }
    
    if (self.highlighted) {
        detailLabelColor = self.highlightedDetailLabelColor;
    }
    
    if (self.selected) {
        detailLabelColor = self.selectedDetailLabelColor;
    }
    
    
    
    _detailLabel.textColor = detailLabelColor;
    
}

//- (void)setHighlighted:(BOOL)highlighted{
//    [super setHighlighted:highlighted];
//    
//}
//
//- (void)setSelected:(BOOL)selected{
//    [super setSelected:selected];
//    
//    
//    
//}


#pragma mark - Layout

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    
    CGRect rect = _weekdayLabel.frame;
    rect.origin.x = CGRectGetWidth(bounds) - CGRectGetWidth(rect) - 5;
    rect.origin.y = 3;
    _weekdayLabel.frame = rect;
    
    CGFloat centerX = floor(CGRectGetMidX(self.contentView.bounds));
    CGFloat offsetY = CGRectGetMaxY(self.dayLabel.frame);
    CGSize labelFitSize = [_detailLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.contentView.bounds), CGFLOAT_MAX)];
    _detailLabel.frame = CGRectIntegral( CGRectMake(0, offsetY + 5, labelFitSize.width, labelFitSize.height) );
    _detailLabel.center = CGPointMake(centerX, _detailLabel.center.y);
    
}

@end
