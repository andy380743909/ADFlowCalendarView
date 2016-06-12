//
//  ADFlowCalendarViewDelegate.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/19.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ADFlowCalendarView;
@class ADFlowCalendarDayCell;
@class ADFlowCalendarSectionData;
@class ADFlowCalendarDayModel;

@protocol ADFlowCalendarViewDelegate <UICollectionViewDelegate>

@optional

- (BOOL)flowCalendarView:(ADFlowCalendarView *)flowCalendarView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath dayModel:(ADFlowCalendarDayModel *)dayModel;
- (void)flowCalendarView:(ADFlowCalendarView *)flowCalendarView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath dayModel:(ADFlowCalendarDayModel *)dayModel;
- (void)flowCalendarView:(ADFlowCalendarView *)flowCalendarView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath dayModel:(ADFlowCalendarDayModel *)dayModel;
- (BOOL)flowCalendarView:(ADFlowCalendarView *)flowCalendarView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath dayModel:(ADFlowCalendarDayModel *)dayModel;
- (BOOL)flowCalendarView:(ADFlowCalendarView *)flowCalendarView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath dayModel:(ADFlowCalendarDayModel *)dayModel; // called when the user taps on an already-selected item in multi-select mode
- (void)flowCalendarView:(ADFlowCalendarView *)flowCalendarView didSelectItemAtIndexPath:(NSIndexPath *)indexPath dayModel:(ADFlowCalendarDayModel *)dayModel;
- (void)flowCalendarView:(ADFlowCalendarView *)flowCalendarView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath dayModel:(ADFlowCalendarDayModel *)dayModel;

@end
