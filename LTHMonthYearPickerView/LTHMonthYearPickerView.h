//
//  LTHMonthYearPickerView.m
//  LTHMonthYearPickerView Demo
//
//  Created by Roland Leth on 30/11/13.
//  Copyright (c) 2014 Roland Leth. All rights reserved.
//

@protocol LTHMonthYearPickerViewDelegate <NSObject>
@optional
- (void)pickerDidSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)pickerDidSelectMonth:(NSString *)month;
- (void)pickerDidSelectYear:(NSString *)year;
- (void)pickerDidSelectMonth:(NSString *)month andYear:(NSString *)year;
- (void)pickerDidPressDoneWithMonth:(NSString *)month andYear:(NSString *)year;
- (void)pickerDidPressCancel;
/**
 *  If you want to change the text field dynamically, as the user changes the values,
 you should implement this method too, so the Cancel button does something.
 *
 *  @param initialValues comes in the form of @{ "month" : month, @"year" : year }
 */
- (void)pickerDidPressCancelWithInitialValues:(NSDictionary *)initialValues;
@end

@interface LTHMonthYearPickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) id<LTHMonthYearPickerViewDelegate> delegate;
@property (nonatomic, strong) UIPickerView *datePicker;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *month;


/**
 *  Month / Year picker view, for those pesky Credit Card expiration dates and alike.
 *
 *  @param date           set to a date if you want the picker to be initialized with a specific month and year.
 *  @param shortMonths    set to YES if you want months to be returned as Jan, Feb, etc, set to NO if you want months to be returned as January, February, etc.
 *  @param numberedMonths set to YES if you want months to be returned as 01, 02, etc.
 *  @param showToolbar    set to YES if you want the picker to have a Cancel/Done toolbar.
 *
 *  @return a container view which contains the UIPicker and toolbar
 */
- (id)initWithDate:(NSDate *)date shortMonths:(BOOL)shortMonths numberedMonths:(BOOL)numberedMonths andToolbar:(BOOL)showToolbar;

@end
