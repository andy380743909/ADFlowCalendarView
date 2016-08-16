//
//  ADCalendarMonthModeViewController.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/5/29.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADCalendarWeekModeViewController.h"

#import "UIView+Border.h"

#import "ADFlowCalendarView.h"
#import "ADFlowCalendarCollectionView.h"
#import "ADWeekModeFlowCalendarViewLayout.h"
#import "ADWeekModeFlowCalendarViewDataSource.h"
#import "ADWeekModeFlowCalendarViewDelegate.h"

#import "NVZuesPriceCalendarWeekModeDataSource.h"
#import "NVZuesPriceCalendarWeekModeDayCell.h"
#import "NVZuesPriceCalendarWeekModeDelegate.h"

@interface ADCalendarWeekModeViewController ()

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *today;

@property (nonnull, strong) ADWeekModeFlowCalendarViewDataSource *dataSourceMonth;
@property (nonnull, strong) ADWeekModeFlowCalendarViewDelegate *delegate;

@property (nonatomic, strong) ADFlowCalendarView *calendarView;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture; // swipe to switch prev/next month

@end

@implementation ADCalendarWeekModeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"WeekMode";
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
    
    ADWeekModeFlowCalendarViewDataSource *dataSource = [[ADWeekModeFlowCalendarViewDataSource alloc] init];
    dataSource.calendar = self.calendar;
    dataSource.today = self.today;
    dataSource.paddingType = ADWeekModeFlowCalendarPaddingWeek;
    
    NSDateComponents *startDataCom = [NSDateComponents new];
    startDataCom.year = 2016;
    startDataCom.month = 4;
    startDataCom.day = 10;
    
    NSDateComponents *endDataCom = [NSDateComponents new];
    endDataCom.year = 2016;
    endDataCom.month = 8;
    endDataCom.day = 7;
    
    dataSource.startDate = [self.calendar dateFromComponents:startDataCom];
    dataSource.endDate = [self.calendar dateFromComponents:endDataCom];
    
    
    
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
    
    
    ADFlowCalendarView *calendarView = [[ADFlowCalendarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bounds), 60)];
    calendarView.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
    
    ADWeekModeFlowCalendarViewLayout *layout = [[ADWeekModeFlowCalendarViewLayout alloc] init];
    calendarView.collectionViewLayout = layout;
    
    // paging enabled
    calendarView.collectionView.pagingEnabled = YES;
    
    calendarView.separatorLineColor = [UIColor colorWithRed:0xe4/255.0f green:0xe4/255.0f blue:0xe4/255.0f alpha:1.0f];
    
    self.dataSourceMonth = [self weekModeDataSource];
    
    [self.dataSourceMonth registerViewClassToFlowCalendar:calendarView];
    
    calendarView.dataSource = self.dataSourceMonth;
    
    self.delegate = [self weekModeDelegate];
    calendarView.delegate = self.delegate;
    
    
    [self.view addSubview:calendarView];
    
    self.calendarView = calendarView;
    
}

- (ADWeekModeFlowCalendarViewDataSource *)weekModeDataSource{
    NVZuesPriceCalendarWeekModeDataSource *dataSource = [[NVZuesPriceCalendarWeekModeDataSource alloc] init];
    dataSource.calendar = self.calendar;
    dataSource.today = self.today;
    dataSource.paddingType = ADWeekModeFlowCalendarPaddingWeek;
    
    NSDateComponents *startDataCom = [NSDateComponents new];
    startDataCom.year = 2016;
    startDataCom.month = 4;
    startDataCom.day = 20;
    
    NSDateComponents *endDataCom = [NSDateComponents new];
    endDataCom.year = 2016;
    endDataCom.month = 8;
    endDataCom.day = 7;
    
    dataSource.startDate = [self.calendar dateFromComponents:startDataCom];
    dataSource.endDate = [self.calendar dateFromComponents:endDataCom];
    return dataSource;
}

- (NVZuesPriceCalendarWeekModeDelegate *)weekModeDelegate{
    NVZuesPriceCalendarWeekModeDelegate *delegate = [[NVZuesPriceCalendarWeekModeDelegate alloc] init];
    
    return delegate;
}


@end
