//
//  UBPickerView.m
//  uBank
//
//  Created by ravil on 5/16/13.
//  Copyright (c) 2013 uBank. All rights reserved.
//

#import "UBPickerView.h"

const CGFloat toolbarHeight = 44;
const CGFloat pickerHeight = 260;

const NSInteger monthComponent = 0;
const NSInteger yearComponent = 1;

@interface UBPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) NSDate *minDate;
@property (strong, nonatomic) NSDate *maxDate;

@property (strong, nonatomic) UIDatePicker *datePickerView;
@property (strong, nonatomic) UIPickerView *monthYearPickerView;
@property (strong, nonatomic) UIView *contentView;

@property (copy, nonatomic) doneBlock doneBlock;
@property (copy, nonatomic) cancelBlock cancelBlock;

@property (strong, nonatomic) NSArray *months;
@property (strong, nonatomic) NSArray *years;

@property (assign, nonatomic) UBPickerType pickerType;

@end


@implementation UBPickerView

#pragma mark - Init Methods

+ (void)showPickerWithType:(UBPickerType)type
                      date:(NSDate *)date
                   minDate:(NSDate *)minDate
                   maxDate:(NSDate *)maxDate
                 doneBlock:(doneBlock)doneBlock
               cancelBlock:(cancelBlock)cancelBlock
{
    UBPickerView *pickerView = [UBPickerView.alloc initWithType:type date:date minDate:minDate maxDate:maxDate];
    
    pickerView.doneBlock = doneBlock;
    pickerView.cancelBlock = cancelBlock;
    
    [pickerView show];
}

- (instancetype)initWithType:(UBPickerType)type
                        date:(NSDate *)date
                     minDate:(NSDate *)minDate
                     maxDate:(NSDate *)maxDate
{
    self = [super initWithFrame:UIScreen.mainScreen.bounds];
    
    if (self)
    {
        self.backgroundColor = UIColor.clearColor;

        self.pickerType = type;
        self.currentDate = date;
        self.minDate = minDate;
        self.maxDate = maxDate;
        
        [self setupContentView];
        [self setupToolbar];
        
        switch (type)
        {
            case UBPickerTypeDate:
                [self setupDatePickerView];
                break;
                
            case UBPickerTypeMonthYear:
                [self setupPickerView];
                [self selectDefaultRowsWithDate:date];
                break;
        }
    }
    
    return self;
}

#pragma mark - Setup Methods

- (void)setupContentView
{
    self.contentView = UIView.new;
    [self addSubview:self.contentView];
    [self setLeadingConstraintToSubview:self.contentView withValue:0];
    [self setTrailingConstraintToSubview:self.contentView withValue:0];
    [self setBottomConstraintToSubview:self.contentView withValue:pickerHeight];
    [self.contentView setHeightConstraintWithValue:pickerHeight];
}

- (void)setupToolbar
{
    UIToolbar *pickerToolbar = UIToolbar.new;
    
    UIImage *backgroundImage = [UIImage imageWithColor:UIColor.whiteColor size:CGSizeMake(self.width, toolbarHeight)];
    [pickerToolbar setBackgroundImage:backgroundImage forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *leftSpace = [UIBarButtonItem.alloc initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    leftSpace.width = 10;

    UIBarButtonItem *cancelBtn = [UIBarButtonItem.alloc initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    
    UIBarButtonItem *flexSpace = [UIBarButtonItem.alloc initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneBtn = [UIBarButtonItem.alloc initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    
    UIBarButtonItem *rightSpace = [UIBarButtonItem.alloc initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    rightSpace.width = 10;

    pickerToolbar.items = @[leftSpace, cancelBtn, flexSpace, doneBtn, rightSpace];
    [self.contentView addSubview:pickerToolbar];
    [self.contentView setLeadingConstraintToSubview:pickerToolbar withValue:0];
    [self.contentView setTrailingConstraintToSubview:pickerToolbar withValue:0];
    [self.contentView setTopConstraintToSubview:pickerToolbar withValue:0];
    [pickerToolbar setHeightConstraintWithValue:44];
}

- (void)setupPickerView
{
    self.monthYearPickerView = UIPickerView.new;
    self.monthYearPickerView.delegate = self;
    self.monthYearPickerView.dataSource = self;
    self.monthYearPickerView.showsSelectionIndicator = YES;
    self.monthYearPickerView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.monthYearPickerView];
    [self.contentView setAllConstraintToSubview:self.monthYearPickerView withInsets:UIEdgeInsetsMake(toolbarHeight, 0, 0, 0)];
}

- (void)setupDatePickerView
{
    self.datePickerView = UIDatePicker.new;
    self.datePickerView.date = self.currentDate ?: NSDate.date;
    self.datePickerView.locale = [NSLocale.alloc initWithLocaleIdentifier:UBLocal.shared.language];
    self.datePickerView.datePickerMode = UIDatePickerModeDate;
    self.datePickerView.backgroundColor = UIColor.whiteColor;
    if (self.minDate)
    {
        self.datePickerView.minimumDate = self.minDate;
    }
    if (self.maxDate)
    {
        self.datePickerView.maximumDate = self.maxDate;
    }
    [self.contentView addSubview:self.datePickerView];
    [self.contentView setAllConstraintToSubview:self.self.datePickerView withInsets:UIEdgeInsetsMake(toolbarHeight, 0, 0, 0)];
}

#pragma mark - Touch Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    if ([touch.view isEqual:self])
    {
        if (self.cancelBlock)
        {
            self.cancelBlock();
        }
        
        [self hidePicker];
    }
}

#pragma mark - Show Methods

- (void)show
{
    [self layoutIfNeeded];
    
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    [window addSubview:self];
    [window addConstraintsToFillSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self setBottomConstraintToSubview:self.contentView withValue:0];
        [self layoutIfNeeded];
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }];
}

- (void)hidePicker
{
    [UIView animateWithDuration:0.25 animations:^{
        [self setBottomConstraintToSubview:self.contentView withValue:pickerHeight];
        [self layoutIfNeeded];
        
        self.backgroundColor = UIColor.clearColor;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Data Methods

- (void)selectDefaultRowsWithDate:(NSDate *)date
{
    if (!date)
    {
        date = NSDate.date;
    }
    
    NSInteger currentYear = date.yearValue;
    NSInteger currentMonth = date.monthValue;
    
    NSInteger indexOfYear = [self.years indexOfObject:[NSString stringWithFormat:@"%li", (long)currentYear]];
    if (indexOfYear == NSNotFound)
    {
        indexOfYear = 0;
    }
    
    NSInteger indexOfMonth = currentMonth - 1;
    
    [self.monthYearPickerView selectRow:indexOfYear inComponent:yearComponent animated:NO];
    [self.monthYearPickerView selectRow:indexOfMonth inComponent:monthComponent animated:NO];
}

- (NSArray *)months
{
    if (!_months)
    {
        NSDateFormatter *dateFormatter = NSDateFormatter.new;
        dateFormatter.locale = [NSLocale.alloc initWithLocaleIdentifier:UBLocal.shared.language];
        _months = dateFormatter.standaloneMonthSymbols;
    }
    
    return _months;
}

- (NSArray *)years
{
    if (!_years)
    {
        NSMutableArray *years = NSMutableArray.new;
        
        NSInteger minYear = self.minDate ? self.minDate.yearValue : 1900;
        NSInteger maxYear = self.maxDate ? self.maxDate.yearValue : 2100;
        
        for (NSInteger year = minYear; year <= maxYear; year++)
        {
            NSString *yearStr = [NSString stringWithFormat:@"%li", (long)year];
            [years addObject:yearStr];
        }
        
        _years = years;
    }
    
    return _years;
}

- (NSDate *)dateWithCurrentRows
{
    NSInteger indexOfMonth = [self.monthYearPickerView selectedRowInComponent:monthComponent];
    NSInteger indexOfYear = [self.monthYearPickerView selectedRowInComponent:yearComponent];
    
    NSDateComponents *components = NSDateComponents.new;
    
    components.month = indexOfMonth + 1;
    components.year = [self.years[indexOfYear] integerValue];
    components.day = 1;
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    components.weekOfMonth = 1;
    
    return [NSCalendar.currentCalendar dateFromComponents:components];
}

#pragma mark - Action Methods

- (void)doneButtonPressed
{
    if (self.doneBlock)
    {
        switch (self.pickerType)
        {
            case UBPickerTypeDate:
                self.doneBlock(self.datePickerView.date);
                break;
                
            case UBPickerTypeMonthYear:
                self.doneBlock(self.dateWithCurrentRows);
                break;
                
            default:
                break;
        }
    }
    
    [self hidePicker];
}

- (void)cancelButtonPressed
{
    if (self.cancelBlock)
    {
        self.cancelBlock();
    }
    
    [self hidePicker];
}

#pragma mark - UIPickerViewDataSource/UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == monthComponent)
    {
        return self.months.count;
    }
    
    return self.years.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 140;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == monthComponent)
    {
        return self.months[row % self.months.count];
    }
    
    return self.years[row % self.years.count];
}

@end
