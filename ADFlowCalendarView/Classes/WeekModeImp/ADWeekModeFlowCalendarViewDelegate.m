//
//  ADMonthModeFlowCalendarViewDelegate.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/21.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADWeekModeFlowCalendarViewDelegate.h"

#import "ADFlowCalendarView.h"

#import "ADFlowCalendarDayModel.h"

@implementation ADWeekModeFlowCalendarViewDelegate

- (BOOL)flowCalendarView:(ADFlowCalendarView *)flowCalendarView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath dayModel:(ADFlowCalendarDayModel *)dayModel;
{
    return !(dayModel.isGhostDay || dayModel.isPaddingDay);
    return YES;
}


- (BOOL)flowCalendarView:(ADFlowCalendarView *)flowCalendarView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath dayModel:(ADFlowCalendarDayModel *)dayModel;
{
    return !(dayModel.isGhostDay || dayModel.isPaddingDay);
    return YES;
}

- (void)flowCalendarView:(ADFlowCalendarView *)flowCalendarView didSelectItemAtIndexPath:(NSIndexPath *)indexPath dayModel:(ADFlowCalendarDayModel *)dayModel{
    
    [flowCalendarView.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}

@end
