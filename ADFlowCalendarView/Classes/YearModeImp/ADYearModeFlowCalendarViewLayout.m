//
//  ADYearModeFlowCalendarViewLayout.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/21.
//  Copyright © 2016年 崔盼军. All rights reserved.
//
#import "ADFlowCalendarCollectionViewLayout.h"
#import "ADYearModeFlowCalendarViewLayout.h"


@implementation ADYearModeFlowCalendarViewLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumInteritemSpacing = 0.0f;
    self.minimumLineSpacing = 0.0f;
    
    // 
    self.calendarViewEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    
    
}

@end