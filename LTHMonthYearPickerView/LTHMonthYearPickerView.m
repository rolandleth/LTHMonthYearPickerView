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

const NSUInteger kMonthComponent = 0;
const NSUInteger kYearComponent = 1;
const NSUInteger kMinYear = 1970;
const NSUInteger kMaxYear = 2060;
const CGFloat kRowHeight = 30.0;

@interface LTHMonthYearPickerView ()

@property (readwrite) NSInteger yearIndex;
@property (readwrite) NSInteger monthIndex;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSMutableArray *years;
@property (nonatomic, strong) NSDictionary *initialValues;
@property (nonatomic) NSUInteger minimumYear;
@property (nonatomic) NSUInteger maximumYear;

@property (nonatomic) NSDate *minimumDate;
@property (nonatomic) NSDate *maximumDate;

@end


@implementation LTHMonthYearPickerView


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (!_initialValues) _initialValues = @{ @"month" : _months[_monthIndex],
																					 @"year" : _years[_yearIndex] };
	if (component == 0) {
		_monthIndex = [_datePicker selectedRowInComponent: 0];
		if ([self.delegate respondsToSelector: @selector(pickerDidSelectMonth:)])
			[self.delegate pickerDidSelectMonth: _months[_monthIndex]];
	}
	else if (component == 1) {
		_yearIndex = [_datePicker selectedRowInComponent: 1];
		if ([self.delegate respondsToSelector: @selector(pickerDidSelectYear:)])
			[self.delegate pickerDidSelectYear: _years[_yearIndex]];
	}
	
	// check if  selected date is valid
	NSInteger selectedYear = [[_years objectAtIndex:_yearIndex] integerValue];
	NSDate *selectedDate = [self dateFromMonth:(_monthIndex + 1) andYear:selectedYear];
	if ([selectedDate compare:_minimumDate] == NSOrderedAscending) {
		_monthIndex = [self getMonthFromDate:_minimumDate] - 1;
	} else if ([selectedDate compare:_maximumDate] == NSOrderedDescending) {
		_monthIndex = [self getMonthFromDate:_maximumDate] - 1;
	}
	[pickerView selectRow:_monthIndex inComponent:0 animated:YES];
	
	if ([self.delegate respondsToSelector: @selector(pickerDidSelectRow:inComponent:)])
		[self.delegate pickerDidSelectRow: row inComponent: component];
	if ([self.delegate respondsToSelector: @selector(pickerDidSelectMonth:andYear:)])
		[self.delegate pickerDidSelectMonth: _months[_monthIndex]
																andYear: _years[_yearIndex]];
	//	[[NSNotificationCenter defaultCenter]
	//     postNotificationName: @"pickerDidSelectRow"
	//     object: self
	//     userInfo: @{ @"row" : @(row), @"component" : @(component) }];
	//	[[NSNotificationCenter defaultCenter] postNotificationName: @"pickerDidSelectYear"
	//														object: self
	//													  userInfo: _years[_currentYear]];
	//	[[NSNotificationCenter defaultCenter] postNotificationName: @"pickerDidSelectMonth"
	//														object: self
	//													  userInfo: _months[_currentMonth]];
	//	[[NSNotificationCenter defaultCenter]
	//     postNotificationName: @"pickerDidSelectMonth"
	//     object: self
	//     userInfo: @{ @"month" : _months[_currentMonth], @"year" : _years[_currentYear] }];
	_year = _years[_yearIndex];
	_month = _months[_monthIndex];
}


//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if (component == kMonthComponent) {
//        return _months[row];
//    }
//    return [NSString stringWithFormat: @"%@", _years[row]];
//}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *label = [[UILabel alloc] initWithFrame: CGRectZero];
	label.textAlignment = NSTextAlignmentCenter;
	if (component == kMonthComponent) {
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
	if (component == kMonthComponent) {
		return _months.count;
	}
	return _years.count;
}


#pragma mark - Actions
- (void)_done {
	if ([self.delegate respondsToSelector: @selector(pickerDidPressDoneWithMonth:andYear:)])
		[self.delegate pickerDidPressDoneWithMonth: _months[_monthIndex]
																			 andYear: _years[_yearIndex]];
	//	[[NSNotificationCenter defaultCenter]
	//     postNotificationName: @"pickerDidPressDone"
	//     object: self
	//     userInfo: @{ @"month" : _months[_currentMonth], @"year" : _years[_currentYear] }];
	_initialValues = nil;
	_year = _years[_yearIndex];
	_month = _months[_monthIndex];
}


- (void)_cancel {
	if (!_initialValues) _initialValues  = @{ @"month" : _months[_monthIndex],
																						@"year" : _years[_yearIndex] };
	if ([self.delegate respondsToSelector: @selector(pickerDidPressCancelWithInitialValues:)]) {
		[self.delegate pickerDidPressCancelWithInitialValues: _initialValues];
		[self.datePicker selectRow: [_months indexOfObject: _initialValues[@"month"]]
									 inComponent: 0
											animated: NO];
		[self.datePicker selectRow: [_years indexOfObject: _initialValues[@"year"]]
									 inComponent: 1
											animated: NO];
	}
	else if ([self.delegate respondsToSelector: @selector(pickerDidPressCancel)])
		[self.delegate pickerDidPressCancel];
	//	[[NSNotificationCenter defaultCenter]
	//     postNotificationName: @"pickerDidPressDone"
	//     object: self
	//     userInfo: _initialValues];
	_monthIndex = [_months indexOfObject: _initialValues[@"month"]];
	_yearIndex = [_years indexOfObject: _initialValues[@"year"]];
	_year = _years[_yearIndex];
	_month = _months[_monthIndex];
	_initialValues = nil;
}



#pragma mark - Init
- (void)_setupComponentsFromDate:(NSDate *)date {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSInteger currentYear = [calendar components: NSCalendarUnitYear
																			fromDate: [NSDate date]].year;
	
	if (currentYear < self.minimumYear) _yearIndex = [_years indexOfObject: [NSString stringWithFormat: @"%lu", (unsigned long)self.minimumYear]];
	else _yearIndex = [_years indexOfObject: [NSString stringWithFormat: @"%lu", (unsigned long)currentYear]];
	_monthIndex = [calendar components: NSCalendarUnitMonth
														fromDate: [NSDate date]].month - 1;
	
	NSDateComponents *dateComponents =
	[calendar components: NSCalendarUnitMonth | NSCalendarUnitYear
							fromDate: date];
	// Set your min year to current year for credit card checks.
	if (self.minimumYear < [_years[_yearIndex] integerValue]) {
		if (dateComponents.year == _yearIndex) {
			if (dateComponents.month >= _monthIndex) {
				_monthIndex = dateComponents.month - 1;
			}
			_yearIndex = [_years indexOfObject: [NSString stringWithFormat: @"%lu", (unsigned long)dateComponents.year]];
		}
		else {
			_yearIndex = [_years indexOfObject: [NSString stringWithFormat: @"%lu", (unsigned long)dateComponents.year]];
			_monthIndex = dateComponents.month - 1;
		}
	}
	
	[_datePicker selectRow: _monthIndex
						 inComponent: 0
								animated: YES];
	[_datePicker selectRow: _yearIndex
						 inComponent: 1
								animated: YES];
	[self performSelector: @selector(_sendFirstPickerValues) withObject: nil afterDelay: 0.1];
}

- (void)_sendFirstPickerValues {
	if ([self.delegate respondsToSelector: @selector(pickerDidSelectRow:inComponent:)]) {
		[self.delegate pickerDidSelectRow: [self.datePicker selectedRowInComponent:0]
													inComponent: 0];
		[self.delegate pickerDidSelectRow: [self.datePicker selectedRowInComponent:1]
													inComponent: 1];
	}
	if ([self.delegate respondsToSelector: @selector(pickerDidSelectMonth:andYear:)])
		[self.delegate pickerDidSelectMonth: _months[_monthIndex]
																andYear: _years[_yearIndex]];
	_year = _years[_yearIndex];
	_month = _months[_monthIndex];
}


#pragma mark - Init
- (id)initWithDate:(NSDate *)date shortMonths:(BOOL)shortMonths numberedMonths:(BOOL)numberedMonths andToolbar:(BOOL)showToolbar
{
	return [self initWithDate:date shortMonths:shortMonths numberedMonths:numberedMonths andToolbar:showToolbar minYear:kMinYear andMaxYear:kMaxYear];
}

- (id)initWithDate:(NSDate *)date shortMonths:(BOOL)shortMonths numberedMonths:(BOOL)numberedMonths andToolbar:(BOOL)showToolbar minDate:(NSDate *)minDate andMaxDate:(NSDate *)maxDate
{
	self.minimumDate = minDate;
	self.maximumDate = maxDate;
	
	NSInteger minYear = [self getYearFromDate:minDate];
	NSInteger maxYear = [self getYearFromDate:maxDate];
	
	return [self initWithDate:date shortMonths:shortMonths numberedMonths:numberedMonths andToolbar:showToolbar minYear:minYear andMaxYear:maxYear];
}

- (id)initWithDate:(NSDate *)date shortMonths:(BOOL)shortMonths numberedMonths:(BOOL)numberedMonths andToolbar:(BOOL)showToolbar minYear:(NSInteger)minYear andMaxYear:(NSInteger)maxYear {
	self = [super init];
	if (self) {
		
		self.minimumYear = minYear;
		self.maximumYear = maxYear;
		
		if (!date) date = [NSDate date];
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDateComponents *dateComponents = [NSDateComponents new];
		NSDateFormatter *dateFormatter = [NSDateFormatter new];
		NSMutableArray *months = [NSMutableArray new];
		dateComponents.month = 1;
		
		if (numberedMonths) [dateFormatter setDateFormat: @"MM"]; // MARK: Change to @"M" if you don't want double digits
		else if (shortMonths) [dateFormatter setDateFormat: @"MMM"];
		else [dateFormatter setDateFormat: @"MMMM"];
		
		for (NSInteger i = 1; i <= 12; i++) {
			[months addObject: [dateFormatter stringFromDate: [calendar dateFromComponents: dateComponents]]];
			dateComponents.month++;
		}
		
		_months = [months copy];
		_years = [NSMutableArray new];
		
		for (NSInteger year = self.minimumYear; year <= self.maximumYear; year++) {
			[_years addObject: [NSString stringWithFormat: @"%lu", (unsigned long)year]];
		}
		
		CGRect datePickerFrame;
		if (showToolbar) {
			self.frame = CGRectMake(0.0, 0.0, kWinSize.width, 260.0);
			datePickerFrame = CGRectMake(0.0, 44.5, self.frame.size.width, 216.0);
			
			UIToolbar *toolbar = [[UIToolbar alloc]
														initWithFrame: CGRectMake(0.0, 0.0, self.frame.size.width, datePickerFrame.origin.y - 0.5)];
			
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
			
			toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			[toolbar setItems: @[cancelButton, flexSpace, doneBtn]
							 animated: YES];
			[self addSubview: toolbar];
		}
		else {
			self.frame = CGRectMake(0.0, 0.0, kWinSize.width, 216.0);
			datePickerFrame = self.frame;
		}
		_datePicker = [[UIPickerView alloc] initWithFrame: datePickerFrame];
		_datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_datePicker.dataSource = self;
		_datePicker.delegate = self;
		[self addSubview: _datePicker];
		[self _setupComponentsFromDate: date];
	}
	return self;
}

#pragma mark - setters

- (void)setMonth:(NSString *)month
{
	_monthIndex = [_months indexOfObject:month];
	[_datePicker selectRow:_monthIndex inComponent:0 animated:NO];
}

- (void)setYear:(NSString *)year
{
	_yearIndex = [_years indexOfObject:year];
	[_datePicker selectRow:_yearIndex inComponent:1 animated:NO];
}

#pragma mark - Date handling methods

- (NSInteger)getMonthFromDate:(NSDate *)date
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:date];
	return components.month;
}

- (NSInteger)getYearFromDate:(NSDate *)date
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:date];
	return components.year;
}

- (NSDate *)dateFromMonth:(NSInteger)month andYear:(NSInteger)year
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [[NSDateComponents alloc] init];
	components.day = 1;
	components.month = month;
	components.year = year;
	return [calendar dateFromComponents:components];
}

@end