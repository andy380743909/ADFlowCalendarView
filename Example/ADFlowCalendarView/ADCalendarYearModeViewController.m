//
//  ViewController.m
//  ADCalendarViewDemo
//
//  Created by 崔盼军 on 16/4/19.
//  Copyright © 2016年 崔盼军. All rights reserved.
//

#import "ADCalendarYearModeViewController.h"

#import "UIView+Border.h"

#import "NSCalendar+ADFlowCalendar.h"
#import "ADFlowCalendarView.h"

#import "ADYearModeFlowCalendarViewLayout.h"

#import "NVZuesPriceCalendarDayCell.h"
#import "NVZuesPriceCalendarDataSource.h"
#import "NVZuesPriceCalendarDelegate.h"

@interface ADCalendarYearModeViewController ()

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *today;

@property (nonnull, strong) ADYearModeFlowCalendarViewDataSource *dataSourceYear;
@property (nonnull, strong) ADYearModeFlowCalendarViewDelegate *delegate;

@end

@implementation ADCalendarYearModeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"YearMode";
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
    
}

- (void)testYearModeDataSource{
    
    ADYearModeFlowCalendarViewDataSource *dataSource = [[ADYearModeFlowCalendarViewDataSource alloc] init];
    dataSource.calendar = self.calendar;
    dataSource.today = self.today;
    dataSource.paddingType = ADYearModeFlowCalendarPaddingWeek;
    
    NSDateComponents *startDataCom = [NSDateComponents new];
    startDataCom.year = 2016;
    startDataCom.month = 5;
    startDataCom.day = 10;
    
    NSDateComponents *endDataCom = [NSDateComponents new];
    endDataCom.year = 2016;
    endDataCom.month = 8;
    endDataCom.day = 7;
    
    dataSource.startDate = [self.calendar dateFromComponents:startDataCom];
    dataSource.endDate = [self.calendar dateFromComponents:endDataCom];
    
    NSArray *sectionDatasArr = [[dataSource sectionDataForSection:0] dayModelArray];
    
    [sectionDatasArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj);
        
        ADFlowCalendarSectionData *sectionData = (ADFlowCalendarSectionData *)obj;
        
        NSLog(@"%@",[sectionData dayModelArray]);
        
    }];
    
}

- (void)setupYearModeCalendarView{
    
    CGRect bounds = self.view.bounds;
    
    
    ADFlowCalendarView *calendarView = [[ADFlowCalendarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds))];
    calendarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    ADYearModeFlowCalendarViewLayout *layout = [[ADYearModeFlowCalendarViewLayout alloc] init];
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
    
    self.dataSourceYear = [self yearModeDataSource];
    
    [self.dataSourceYear registerViewClassToFlowCalendar:calendarView];
    
    calendarView.dataSource = self.dataSourceYear;
    
    self.delegate = [self yearModeDelegate];
    calendarView.delegate = self.delegate;
    
    
    [self.view addSubview:calendarView];
    
}

- (ADYearModeFlowCalendarViewDataSource *)yearModeDataSource{
    ADYearModeFlowCalendarViewDataSource *dataSource = [[NVZuesPriceCalendarDataSource alloc] init];
    dataSource.calendar = self.calendar;
    dataSource.today = self.today;
    dataSource.paddingType = ADYearModeFlowCalendarPaddingWeek;
    
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
    return dataSource;
}

- (ADYearModeFlowCalendarViewDelegate *)yearModeDelegate{
    NVZuesPriceCalendarDelegate *delegate = [[NVZuesPriceCalendarDelegate alloc] init];
    
    return delegate;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
