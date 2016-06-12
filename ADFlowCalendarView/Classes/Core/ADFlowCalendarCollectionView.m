//
//  ADFlowCalendarCollectionView.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/20.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADFlowCalendarCollectionView.h"

@implementation ADFlowCalendarCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.scrollsToTop = NO;
//    self.delaysContentTouches = NO;
    
}



@end
