//
//  ADCalendarMonthModeViewController.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/5/29.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADCalendarMonthModeViewController.h"

#import "UIView+Border.h"

#import "ADFlowCalendarView.h"
#import "ADMonthModeFlowCalendarViewLayout.h"
#import "ADMonthModeFlowCalendarViewDataSource.h"
#import "ADMonthModeFlowCalendarViewDelegate.h"

#import "NVZuesPriceCalendarMonthModeDataSource.h"
#import "NVZuesPriceCalendarMonthModeDayCell.h"
#import "NVZuesPriceCalendarMonthModeDelegate.h"

@interface ADCalendarMonthModeViewController ()

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *today;

@property (nonnull, strong) ADMonthModeFlowCalendarViewDataSource *dataSourceMonth;
@property (nonnull, strong) ADMonthModeFlowCalendarViewDelegate *delegate;

@property (nonatomic, strong) ADFlowCalendarView *calendarView;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture; // swipe to switch prev/next month

@end

@implementation ADCalendarMonthModeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"MonthMode";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.calendar.firstWeekday = 2;
    self.calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    self.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    
    self.today = [NSDate date];
    
    [self setupYearModeCalendarView];
    
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureDidSwiped:)];
    [self.calendarView addGestureRecognizer:self.swipeGesture];
    
}

#pragma mark - Actions

- (void)swipeGestureDidSwiped:(UISwipeGestureRecognizer *)gesture{
    
    
    
}

#pragma mark -

- (void)testYearModeDataSource{
    
    ADMonthModeFlowCalendarViewDataSource *dataSource = [[ADMonthModeFlowCalendarViewDataSource alloc] init];
    dataSource.calendar = self.calendar;
    dataSource.today = self.today;
    dataSource.paddingType = ADMonthModeFlowCalendarPaddingWeek;
    
    NSDateComponents *monthCom = [NSDateComponents new];
    monthCom.era = 1;
    monthCom.year = 2016;
    monthCom.month = 5;
    
    dataSource.yearMonthDateComponents = monthCom;
    
    
    
//    dataSource.startDate = [self.calendar dateFromComponents:startDataCom];
//    dataSource.endDate = [self.calendar dateFromComponents:endDataCom];
//    
//    NSArray *sectionDatasArr = [[dataSource sectionDataForSection:0] dayModelArray];
//    
//    [sectionDatasArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"%@",obj);
//        
//        ADFlowCalendarSectionData *sectionData = (ADFlowCalendarSectionData *)obj;
//        
//        NSLog(@"%@",[sectionData dayModelArray]);
//        
//    }];
    
}

- (void)setupYearModeCalendarView{
    
    CGRect bounds = self.view.bounds;
    
    
    ADFlowCalendarView *calendarView = [[ADFlowCalendarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds))];
    calendarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    ADMonthModeFlowCalendarViewLayout *layout = [[ADMonthModeFlowCalendarViewLayout alloc] init];
    calendarView.collectionViewLayout = layout;
    
    calendarView.separatorLineColor = [UIColor colorWithRed:0xe4/255.0f green:0xe4/255.0f blue:0xe4/255.0f alpha:1.0f];
    
    ADFlowCalendarWeekdaySymbolsHeadView *weekdaySymbolHeadV = [[ADFlowCalendarWeekdaySymbolsHeadView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bounds), 25)];
    
    weekdaySymbolHeadV.weekdaySymbols = [self.calendar adflow_standaloneVeryShortWeekdaySymbols];
    weekdaySymbolHeadV.contentInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    
    NSDictionary *styleBottom = @{
                                  @"width":@(1),
                                  @"inset":NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0, 0, 0, 0)),
                                  @"color":calendarView.separatorLineColor
                                  };
    [weekdaySymbolHeadV setBorderWithStyle:styleBottom forEdge:UIViewBorderEdgeBottom];
    
    calendarView.weekdaySymbolHeadView = weekdaySymbolHeadV;
    
    self.dataSourceMonth = [self monthModeDataSource];
    
    [self.dataSourceMonth registerViewClassToFlowCalendar:calendarView];
    
    calendarView.dataSource = self.dataSourceMonth;
    
    self.delegate = [self monthModeDelegate];
    calendarView.delegate = self.delegate;
    
    
    [self.view addSubview:calendarView];
    
    self.calendarView = calendarView;
    
}

- (ADMonthModeFlowCalendarViewDataSource *)monthModeDataSource{
    NVZuesPriceCalendarMonthModeDataSource *dataSource = [[NVZuesPriceCalendarMonthModeDataSource alloc] init];
    dataSource.calendar = self.calendar;
    dataSource.today = self.today;
    dataSource.paddingType = ADMonthModeFlowCalendarPaddingSixWeeks;
    
    NSDateComponents *monthCom = [NSDateComponents new];
    monthCom.era = 1;
    monthCom.year = 2016;
    monthCom.month = 4;
    
    dataSource.yearMonthDateComponents = monthCom;
    return dataSource;
}

- (NVZuesPriceCalendarMonthModeDelegate *)monthModeDelegate{
    NVZuesPriceCalendarMonthModeDelegate *delegate = [[NVZuesPriceCalendarMonthModeDelegate alloc] init];
    
    return delegate;
}


@end
