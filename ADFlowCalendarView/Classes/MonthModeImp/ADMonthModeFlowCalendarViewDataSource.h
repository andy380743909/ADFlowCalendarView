//
//  ADMonthModeFlowCalendarViewDataSource.h
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/21.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADFlowCalendarViewDataSource.h"

typedef NS_ENUM(NSInteger, ADMonthModeFlowCalendarPaddingType) {
    ADMonthModeFlowCalendarPaddingNone,
    ADMonthModeFlowCalendarPaddingWeek,
    ADMonthModeFlowCalendarPaddingMonth, /* unimplemented */
    ADMonthModeFlowCalendarPaddingSixWeeks /* with this mode, we can keep the calendar has the same height rowHeight*6 */
};

@interface ADMonthModeFlowCalendarViewDataSource : NSObject<ADFlowCalendarViewDataSource>

@property (nonatomic, copy) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *today;

// only ear,year,month will be used
@property (nonatomic, strong) NSDateComponents *yearMonthDateComponents;

@property (nonatomic, assign) ADMonthModeFlowCalendarPaddingType paddingType;

// override this to do some customize initializing
- (void)commonInit;

- (NSString *)currentMonthTitle;

- (NSDateComponents *)prevMonthDateComponents;
- (NSDateComponents *)nextMonthDateComponents;

@end
