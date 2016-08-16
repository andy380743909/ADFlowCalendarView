//
//  ADMonthModeFlowCalendarViewLayout.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/21.
//  Copyright © 2016年 崔盼军. All rights reserved.
//
#import "ADFlowCalendarCollectionViewLayout.h"
#import "ADWeekModeFlowCalendarViewLayout.h"

@implementation ADWeekModeFlowCalendarViewLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumInteritemSpacing = 0.0f;
    self.minimumLineSpacing = 0.0f;
    
    //
    self.calendarViewEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    
    
}

// no need for sectionHeader and sectionFooter, we can filter out attributes for UICollectionElementCategorySupplementaryView
// we can also return CGSizeZero for sectionHeader and sectionFooter to hidden the views.
//- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;
//{
//    NSArray *layoutAttrs = [super layoutAttributesForElementsInRect:rect];
//    return layoutAttrs;
//}


- (CGSize)sizeForMonthHeadViewAtSection:(NSInteger)section{
    return CGSizeZero;
}

#pragma mark - Override

// using UIScrollView pagingEnabled would be better
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity;
{
    CGPoint targetContentOffset = proposedContentOffset;
    
    CGRect collectionViewBounds = self.collectionView.bounds;
    CGFloat width = CGRectGetWidth(collectionViewBounds);
    
    targetContentOffset.x = width * round(proposedContentOffset.x/width);
    
    return targetContentOffset;
}

@end