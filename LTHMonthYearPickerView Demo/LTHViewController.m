//
//  LTHViewController.m
//  LTHMonthYearPickerView Demo
//
//  Created by Roland Leth on 30/11/13.
//  Copyright (c) 2014 Roland Leth. All rights reserved.
//

#import "LTHViewController.h"


@interface LTHViewController ()

@property (nonatomic, strong) UITextField *dateTextField;
@property (nonatomic, strong) LTHMonthYearPickerView *monthYearPicker;
@end


@implementation LTHViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	CGSize winSize = [UIScreen mainScreen].bounds.size;
	_dateTextField = [[UITextField alloc] initWithFrame: CGRectMake(winSize.width * 0.5 - 75.0,
																	winSize.height * 0.5 - 20.0,
																	150.0,
																	40.0)];
	
	_monthYearPicker = [[LTHMonthYearPickerView alloc] initWithDate: [NSDate date]
														shortMonths: NO
													 numberedMonths: NO
														 andToolbar: YES];
	_monthYearPicker.delegate = self;
	_dateTextField.delegate = self;
	_dateTextField.textAlignment = NSTextAlignmentCenter;
	_dateTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
	_dateTextField.layer.borderWidth = 1.0;
	_dateTextField.textColor = [UIColor purpleColor];
	_dateTextField.tintColor = [UIColor purpleColor];
	_dateTextField.inputView = _monthYearPicker;
	[self.view addSubview: _dateTextField];
}


#pragma mark - LTHMonthYearPickerView Delegate
- (void)pickerDidPressDoneWithMonth:(NSString *)month andYear:(NSString *)year {
    _dateTextField.text = [NSString stringWithFormat: @"%@ / %@", month, year];
	[_dateTextField resignFirstResponder];
}


- (void)pickerDidPressCancel {
	[_dateTextField resignFirstResponder];
}


- (void)pickerDidSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (component == 0) {
		NSLog(@"Month: %@", _monthYearPicker.months[row]);
	}
	else {
		NSLog(@"Year: %@", _monthYearPicker.years[row]);
	}
}


@end
