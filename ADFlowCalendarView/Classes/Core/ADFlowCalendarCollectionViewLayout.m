//
//  ADFlowCalendarCollectionViewLayout.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/20.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADFlowCalendarCollectionViewLayout.h"

@interface ADFlowCalendarCollectionViewLayout ()

// unit in pixel
@property (nonatomic, assign) NSUInteger itemWidth;
@property (nonatomic, assign) NSUInteger littleHalfRemain;
@property (nonatomic, assign) NSUInteger bigHalfRemain;

@property (nonatomic, assign) CGFloat currentScale;

@end

@implementation ADFlowCalendarCollectionViewLayout


- (void)prepareLayout{
    [super prepareLayout];
    
    CGRect collectionViewBounds = self.collectionView.bounds;
    
    [self pixelPerfectDivisionTotalLength:CGRectGetWidth(collectionViewBounds)
                              paddingHead:self.calendarViewEdgeInsets.left
                              paddingTail:self.calendarViewEdgeInsets.right
                                    count:7
     
                                avgLength:&_itemWidth
                         littleHalfRemain:&_littleHalfRemain
                            bigHalfRemain:&_bigHalfRemain];
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    self.currentScale = scale;
    
    CGRect collectionViewBounds = self.collectionView.bounds;
    
    [self pixelPerfectDivisionTotalLength:CGRectGetWidth(newBounds)
                              paddingHead:self.calendarViewEdgeInsets.left
                              paddingTail:self.calendarViewEdgeInsets.right
                                    count:7
     
                                avgLength:&_itemWidth
                         littleHalfRemain:&_littleHalfRemain
                            bigHalfRemain:&_bigHalfRemain];
    
    return !CGSizeEqualToSize(collectionViewBounds.size, newBounds.size);
}


- (void)pixelPerfectDivisionTotalLength:(NSUInteger)totalLength
                            paddingHead:(NSInteger)paddingHead
                            paddingTail:(NSInteger)paddingTail
                                  count:(NSUInteger)count

                              avgLength:(out NSUInteger *)avgLengthOut
                       littleHalfRemain:(out NSUInteger *)littleHalfRemainOut
                          bigHalfRemain:(out NSUInteger *)bigHalfRemainOut
{
    
    NSAssert(count > 0, @"不能除0");
    
    NSUInteger contentLength = totalLength - paddingHead - paddingTail;
    
    NSUInteger avgLength = contentLength / count;
    
    NSUInteger totalContentRemain = contentLength - avgLength * count;
    
    NSUInteger littleHalfRemain = totalContentRemain/2;
    NSUInteger bigHalfRemain = totalContentRemain - littleHalfRemain;
    
    if (avgLengthOut != NULL) {
        *avgLengthOut = avgLength;
    }
    
    if (littleHalfRemainOut != NULL) {
        *littleHalfRemainOut = littleHalfRemain;
    }
    
    if (bigHalfRemainOut != NULL) {
        *bigHalfRemainOut = bigHalfRemain;
    }
}


- (CGSize)sizeForDayViewAtIndexPath:(NSIndexPath *)indexPath{
    CGSize dayViewSize = CGSizeZero;
    
//    CGRect collectionViewBounds = self.collectionView.bounds;
    
    CGRect collectionViewBounds = self.collectionView.bounds;
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    self.currentScale = scale;
    
    [self pixelPerfectDivisionTotalLength:CGRectGetWidth(collectionViewBounds)
                              paddingHead:self.calendarViewEdgeInsets.left
                              paddingTail:self.calendarViewEdgeInsets.right
                                    count:7
     
                                avgLength:&_itemWidth
                         littleHalfRemain:&_littleHalfRemain
                            bigHalfRemain:&_bigHalfRemain];
    
    UIEdgeInsets calendarInsets = self.calendarViewEdgeInsets;
    
    CGFloat dayWidth = self.itemWidth;
    
    NSInteger item = indexPath.item%7;
    if (item == 0) {
        dayWidth += calendarInsets.left + self.littleHalfRemain;
    }else if (item == 6){
        dayWidth += calendarInsets.right + self.bigHalfRemain;
    }
    
    dayViewSize.width = dayWidth;
    dayViewSize.height = 60;
    return dayViewSize;
}

- (UIEdgeInsets)contentInsetsForDayViewAtIndexPath:(NSIndexPath *)indexPath{
    UIEdgeInsets contentInsetsForDay = UIEdgeInsetsZero;
    UIEdgeInsets calendarInsets = self.calendarViewEdgeInsets;
    NSInteger item = indexPath.item%7;
    if (item == 0) {
        contentInsetsForDay.left = calendarInsets.left + self.littleHalfRemain;
    }else if (item == 6){
        contentInsetsForDay.right = calendarInsets.right + self.bigHalfRemain;
    }
    return contentInsetsForDay;
}

- (CGSize)sizeForMonthHeadViewAtSection:(NSInteger)section{
    
    CGRect collectionViewBounds = self.collectionView.bounds;
    
    return CGSizeMake(CGRectGetWidth(collectionViewBounds), 45);
}



- (UIEdgeInsets)contentInsetsAtSection:(NSInteger)section{
    
    id<UICollectionViewDelegateFlowLayout> layoutDelegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    if ([layoutDelegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        UIEdgeInsets insets = [layoutDelegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        return insets;
    }
    return self.sectionInset;
//    return UIEdgeInsetsMake(0, 5, 0, 5);
}

@end
