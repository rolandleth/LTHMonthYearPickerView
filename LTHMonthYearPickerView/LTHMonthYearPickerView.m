//
//  LTHMonthYearPickerView.m
//  LTHMonthYearPickerView Demo
//
//  Created by Roland Leth on 30/11/13.
//  Copyright (c) 2014 Roland Leth. All rights reserved.
//

#import "LTHMonthYearPickerView.h"

#define kMonthColor [UIColor grayColor]
#define kYearColor [UIColor darkGrayColor]
#define kMonthFont [UIFont systemFontOfSize: 22.0]
#define kYearFont [UIFont systemFontOfSize: 22.0]
#define kWinSize [UIScreen mainScreen].bounds.size

const NSUInteger kMonthIndex = 0;
const NSUInteger kYearIndex = 1;
const NSUInteger kMinYear = 2014;
const NSUInteger kMaxYear = 2040;
const CGFloat kRowHeight = 30.0;

const NSString *kJanuary = @"January";
const NSString *kFebruary = @"February";
const NSString *kMarch = @"March";
const NSString *kApril = @"April";
const NSString *kMay = @"May";
const NSString *kJune = @"June";
const NSString *kJuly = @"July";
const NSString *kAugust = @"August";
const NSString *kSeptember = @"September";
const NSString *kOctober = @"October";
const NSString *kNovember = @"November";
const NSString *kDecember = @"December";

const NSString *kJan = @"Jan";
const NSString *kFeb = @"Feb";
const NSString *kMar = @"Mar";
const NSString *kApr = @"Apr";
const NSString *kJun = @"Jun";
const NSString *kJul = @"Jul";
const NSString *kAug = @"Aug";
const NSString *kSep = @"Sep";
const NSString *kOct = @"Oc";
const NSString *kNov = @"Nov";
const NSString *kDec = @"Dec";


@interface LTHMonthYearPickerView ()

@property (nonatomic, strong) NSDate *date;
@property (readwrite) NSInteger currentYear;
@property (readwrite) NSInteger currentMonth;

@end


@implementation LTHMonthYearPickerView


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([self.delegate respondsToSelector: @selector(pickerDidSelectRow:inComponent:)])
        [self.delegate pickerDidSelectRow: row inComponent: component];
//	[[NSNotificationCenter defaultCenter] postNotificationName: @"pickerDidSelectRow"
//														object: self
//													  userInfo: @{@"row" : @(row),
//                                                                  @"component" : @(component)}];
}


//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if (component == kMonthIndex) {
//        return _months[row];
//    }
//    return [NSString stringWithFormat: @"%@", _years[row]];
//}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *label = [[UILabel alloc] initWithFrame: CGRectZero];
	label.textAlignment = NSTextAlignmentCenter;
	if (component == kMonthIndex) {
		label.text = [NSString stringWithFormat: @"%@", _months[row]];
		label.textColor = kMonthColor;
		label.font = kMonthFont;
		label.frame = CGRectMake(0, 0, kWinSize.width * 0.5, kRowHeight);
	}
	else {
		label.text = [NSString stringWithFormat: @"%@", _years[row]];
		label.textColor = kYearColor;
		label.font = kYearFont;
		label.frame = CGRectMake(kWinSize.width * 0.5, 0, kWinSize.width * 0.5, kRowHeight);
	}
	return label;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.bounds.size.width / 2;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return kRowHeight;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == kMonthIndex) {
        return _months.count;
    }
    return _years.count;
}


#pragma mark - Actions
- (void)_done {
    if ([self.delegate respondsToSelector: @selector(pickerDidPressDoneWithMonth:andYear:)])
        [self.delegate pickerDidPressDoneWithMonth: _months[[_datePicker selectedRowInComponent: 0]]
										   andYear: _years[[_datePicker selectedRowInComponent: 1]]];
//	[[NSNotificationCenter defaultCenter] postNotificationName: @"pickerDidPressDone"
//														object: self
//													  userInfo: @{@"month" : _months[[_datePicker selectedRowInComponent: 0],
//                                                                  @"year" : _years[[_datePicker selectedRowInComponent: 1]]}];
}


- (void)_cancel {
    if ([self.delegate respondsToSelector: @selector(pickerDidPressCancel)])
        [self.delegate pickerDidPressCancel];
//	[[NSNotificationCenter defaultCenter] postNotificationName: @"pickerDidPressDone"
//														object: self
//													  userInfo: nil];
}



#pragma mark - Init
- (void)_setupComponents {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    _currentYear = [calendar components: NSCalendarUnitYear
                               fromDate: [NSDate date]].year;
    _currentMonth = [calendar components: NSCalendarUnitMonth
                                fromDate: [NSDate date]].month;
    if (!_date) {
        [_datePicker selectRow: _currentMonth - 1
				   inComponent: 0
					  animated: YES];
        [_datePicker selectRow: [_years indexOfObject: @(_currentYear)]
				   inComponent: 1
					  animated: YES];
    }
    else {
        NSDateComponents *dateComponents = [calendar components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                       fromDate: _date];
        if (dateComponents.year < _currentYear) {
            [_datePicker selectRow: _currentMonth - 1
					   inComponent: 0
						  animated: YES];
            [_datePicker selectRow: [_years indexOfObject: @(_currentYear)]
					   inComponent: 1
						  animated: YES];
        }
        else if (dateComponents.year == _currentYear) {
            if (dateComponents.month < _currentMonth) {
                [_datePicker selectRow: _currentMonth - 1
						   inComponent: 0
							  animated: YES];
            }
            else {
                [_datePicker selectRow: dateComponents.month - 1
						   inComponent: 0
							  animated: YES];
            }
            [_datePicker selectRow: [_years indexOfObject: @(_currentYear)]
					   inComponent: 1
						  animated: YES];
        }
        else {
            [_datePicker selectRow: dateComponents.month - 1
					   inComponent: 0
						  animated: YES];
            [_datePicker selectRow: [_years indexOfObject: @(dateComponents.year)]
					   inComponent: 1
						  animated: YES];
        }
    }
}


#pragma mark - Init
- (id)initWithDate:(NSDate *)date shortMonths:(BOOL)shortMonths numberedMonths:(BOOL)numberedMonths andToolbar:(BOOL)showToolbar {
    self = [super init];
    if (self) {
        _date = date;
        if (numberedMonths)
            _months = @[@"01", @"02", @"03", @"04", @"05", @"06",
                        @"07", @"08", @"09", @"10", @"11", @"12"];
        else if (shortMonths)
			_months = @[kJan, kFeb, kMar, kApr, kMay, kJun, kJul, kAug, kSep, kOct, kNov, kDec];
		else
            _months = @[kJanuary, kFebruary, kMarch, kApril, kMay, kJune,
						kJuly, kAugust, kSeptember, kOctober, kNovember, kDecember];
        _years = [[NSMutableArray alloc] initWithCapacity: kMaxYear - kMinYear + 1];
        for (NSInteger year = kMinYear; year <= kMaxYear; year++) {
            [_years addObject: @(year)];
        }
        
		CGRect datePickerFrame;
        if (showToolbar) {
			datePickerFrame = CGRectMake((kWinSize.width - kWinSize.width) / 2, 42, 320.0, 216.0);
            UIToolbar *toolbar = [[UIToolbar alloc]
                                  initWithFrame: CGRectMake(0, 0, kWinSize.width, 44.0)];
            
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                             target: self
                                             action: @selector(_cancel)];
            UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                          target: self
                                          action: nil];
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                        target: self
                                        action: @selector(_done)];
            
            [toolbar setItems: [NSArray arrayWithObjects:cancelButton,flexSpace,doneBtn, nil]
                     animated: YES];
            [self addSubview: toolbar];
            
            self.frame = CGRectMake(0.0, 0.0, kWinSize.width, 256.0);
        }
        else {
			datePickerFrame = CGRectMake((kWinSize.width - kWinSize.width) / 2, 0.0, 320.0, 216.0);
			self.frame = CGRectMake(0.0, 0.0, kWinSize.width, 216.0);
		}
        _datePicker = [[UIPickerView alloc] initWithFrame: datePickerFrame];
        _datePicker.dataSource = self;
        _datePicker.delegate = self;
        [self addSubview: _datePicker];
        [self _setupComponents];
    }
    return self;
}


@end
