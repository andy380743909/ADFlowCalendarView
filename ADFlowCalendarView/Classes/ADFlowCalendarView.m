//
//  ADFlowCalendarView.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/19.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADFlowCalendarView.h"
#import "ADFlowCalendarDayCell.h"

@interface ADFlowCalendarView ()

@property (nonatomic, strong) ADFlowCalendarCollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *sectionDataMutableArray;


@end

@implementation ADFlowCalendarView

@synthesize calendar = _calendar;

- (Class)collectionViewClass
{
    return [ADFlowCalendarCollectionView class];
}



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
    self.backgroundColor = [UIColor whiteColor];
    
}


#pragma mark - LifeCycle

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    // refreshViews
    [self refreshViews];
    
}

#pragma mark - Reload

- (void)reloadData{
    
    self.sectionDataMutableArray = nil;
    
    [self refreshViews];
}

- (void)refreshViews{
    // weekdaySymbolsHeadView
    
//    ADFlowCalendarWeekdaySymbolsHeadView *headV = nil;
//    if (_dataSource && [_dataSource respondsToSelector:@selector(weekdaySymbolHeadViewOfFlowCalendarView:)]) {
//        headV = [_dataSource weekdaySymbolHeadViewOfFlowCalendarView:self];
//    }
//    
//    [self addSubview:headV];
//    _weekdaySymbolHeadView = headV;
    
    // collectionView
    [self.collectionView reloadData];
}

#pragma mark - Layout

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
//    CGFloat offsetY = 0.0f;
    
    CGRect rect = self.weekdaySymbolHeadView.frame;
    rect.origin = CGPointZero;
    rect.size.width = CGRectGetWidth(bounds);
    
    self.weekdaySymbolHeadView.frame = CGRectIntegral(rect);
    
    //
    
    self.collectionView.frame = [self collectionViewFrame];
    if (!self.collectionView.superview) {
        [self addSubview:self.collectionView];
    } else {
//        [self.collectionViewLayout invalidateLayout];
//        [self.collectionViewLayout prepareLayout];
    }
    
}

#pragma mark - Model Query

- (ADFlowCalendarSectionData *)sectionDataAtSection:(NSInteger)section{
    ADFlowCalendarSectionData *sectionData = [self.sectionDataMutableArray objectAtIndex:section];
    return sectionData;
}

- (ADFlowCalendarDayModel *)dayModelAtIndexPath:(NSIndexPath *)indexPath{
    ADFlowCalendarSectionData *sectionData = [self sectionDataAtSection:indexPath.section];
    ADFlowCalendarDayModel *dayModel = [sectionData dayModelAtIndex:indexPath.item];
    return dayModel;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.sectionDataMutableArray == nil) {
        if (_dataSource && [_dataSource respondsToSelector:@selector(sectionDatasInFlowCalendarView:)]) {
            NSArray *sectionDataFromDataSource = [_dataSource sectionDatasInFlowCalendarView:self];
            if (sectionDataFromDataSource == nil || [sectionDataFromDataSource count] == 0) {
                
                // TODO
                
            }
            self.sectionDataMutableArray = [NSMutableArray arrayWithArray:sectionDataFromDataSource];
        }else{
            // TODO
        }
    }
    return [self.sectionDataMutableArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(flowCalendarView:numberOfItemsInSection:flowCalendarSectionData:)]) {
        ADFlowCalendarSectionData *sectionData = [self.sectionDataMutableArray objectAtIndex:section];
        NSInteger numberOfItems = [_dataSource flowCalendarView:self numberOfItemsInSection:section flowCalendarSectionData:sectionData];
        return numberOfItems;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ADFlowCalendarDayCell *cell = nil;
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(flowCalendarView:dayCellAtIndexPath:flowCalendarSectionData:)]) {
        ADFlowCalendarSectionData *sectionData = [self.sectionDataMutableArray objectAtIndex:indexPath.section];
        cell = (ADFlowCalendarDayCell *)[_dataSource flowCalendarView:self dayCellAtIndexPath:indexPath flowCalendarSectionData:sectionData];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(flowCalendarView:monthHeadViewAtIndexPath:flowCalendarSectionData:)]) {
            ADFlowCalendarSectionData *sectionData = [self.sectionDataMutableArray objectAtIndex:indexPath.section];
            UICollectionReusableView *monthHeaderView = (UICollectionReusableView *)[_dataSource flowCalendarView:self monthHeadViewAtIndexPath:indexPath flowCalendarSectionData:sectionData];
            return monthHeaderView;
        }
        
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ADFlowCalendarDayModel *dayModel = [self dayModelAtIndexPath:indexPath];
    
    if (_delegate && [_delegate respondsToSelector:@selector(flowCalendarView:shouldHighlightItemAtIndexPath:dayModel:)]) {
        return [_delegate flowCalendarView:self shouldHighlightItemAtIndexPath:indexPath dayModel:dayModel];
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    ADFlowCalendarDayModel *dayModel = [self dayModelAtIndexPath:indexPath];
    if (_delegate && [_delegate respondsToSelector:@selector(flowCalendarView:didHighlightItemAtIndexPath:dayModel:)]) {
        [_delegate flowCalendarView:self didHighlightItemAtIndexPath:indexPath dayModel:dayModel];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ADFlowCalendarDayModel *dayModel = [self dayModelAtIndexPath:indexPath];
    if (_delegate && [_delegate respondsToSelector:@selector(flowCalendarView:didUnhighlightItemAtIndexPath:dayModel:)]) {
        [_delegate flowCalendarView:self didUnhighlightItemAtIndexPath:indexPath dayModel:dayModel];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ADFlowCalendarDayModel *dayModel = [self dayModelAtIndexPath:indexPath];
    if (_delegate && [_delegate respondsToSelector:@selector(flowCalendarView:shouldSelectItemAtIndexPath:dayModel:)]) {
        return [_delegate flowCalendarView:self shouldSelectItemAtIndexPath:indexPath dayModel:dayModel];
    }
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ADFlowCalendarDayModel *dayModel = [self dayModelAtIndexPath:indexPath];
    if (_delegate && [_delegate respondsToSelector:@selector(flowCalendarView:shouldDeselectItemAtIndexPath:dayModel:)]) {
        return [_delegate flowCalendarView:self shouldDeselectItemAtIndexPath:indexPath dayModel:dayModel];
    }
    return NO;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ADFlowCalendarDayModel *dayModel = [self dayModelAtIndexPath:indexPath];
    if (_delegate && [_delegate respondsToSelector:@selector(flowCalendarView:didSelectItemAtIndexPath:dayModel:)]) {
        [_delegate flowCalendarView:self didSelectItemAtIndexPath:indexPath dayModel:dayModel];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ADFlowCalendarDayModel *dayModel = [self dayModelAtIndexPath:indexPath];
    if (_delegate && [_delegate respondsToSelector:@selector(flowCalendarView:didDeselectItemAtIndexPath:dayModel:)]) {
        [_delegate flowCalendarView:self didDeselectItemAtIndexPath:indexPath dayModel:dayModel];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [_delegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [_delegate scrollViewDidEndDecelerating:scrollView];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(ADFlowCalendarCollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize headerSize = [collectionViewLayout sizeForMonthHeadViewAtSection:section];
    return headerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(ADFlowCalendarCollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    CGSize size = [collectionViewLayout sizeForDayViewAtIndexPath:indexPath];
    //NSLog(@"%@=======%@",indexPath,NSStringFromCGSize(size));
    return size;
}


#pragma mark -

- (NSCalendar *)calendar{
    if (_calendar == nil) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _calendar;
}

- (void)setCalendar:(NSCalendar *)calendar{
    _calendar = [calendar copy];
    [self reloadData];
}

- (ADFlowCalendarCollectionView *)collectionView{
    if (_collectionView == nil) {
        
        _collectionView = [[(id)[self collectionViewClass] alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView reloadData];
        [_collectionView layoutIfNeeded];
    }
    
    return _collectionView;
}

- (void)setCollectionViewLayout:(ADFlowCalendarCollectionViewLayout *)collectionViewlayout{
    _collectionViewLayout = collectionViewlayout;
    if (_collectionView) {
        self.collectionView.collectionViewLayout = _collectionViewLayout;
    }
}

- (void)setWeekdaySymbolHeadView:(ADFlowCalendarWeekdaySymbolsHeadView *)weekdaySymbolHeadView{
    [_weekdaySymbolHeadView removeFromSuperview];
    
    if (weekdaySymbolHeadView) {
        _weekdaySymbolHeadView = weekdaySymbolHeadView;
        [self addSubview:_weekdaySymbolHeadView];
    }
    
    if (_collectionView) {
        self.collectionView.frame = [self collectionViewFrame];
    }
    
}


- (CGRect)weekdaySymbolHeadViewFrame{
    return self.weekdaySymbolHeadView.frame;
}

- (CGRect)collectionViewFrame
{
    CGFloat daysOfWeekViewHeight = CGRectGetHeight([self weekdaySymbolHeadViewFrame]);
    
    CGRect collectionViewFrame = self.bounds;
    collectionViewFrame.origin.y += daysOfWeekViewHeight;
    collectionViewFrame.size.height -= daysOfWeekViewHeight;
    return collectionViewFrame;
}

@end