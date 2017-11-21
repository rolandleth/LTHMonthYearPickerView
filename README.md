# LTHMonthYearPickerView
Simple to use month & year picker view for those pesky Credit Card expiration dates & Co.

# How to use
Drag the contents of `LTHMonthYearPickerView` to your project, or add `pod 'LTHMonthYearPickerView'` to your podspec file.

```objc
/**
 *  Month / Year picker view, for those pesky Credit Card expiration dates and alike.
 *
 *  @param date           set to a date if you want the picker to be initialized with a specific month and year, otherwise it is initialized with the current month and year.
 *  @param shortMonths    set to YES if you want months to be returned as Jan, Feb, etc, set to NO if you want months to be returned as January, February, etc.
 *  @param numberedMonths set to YES if you want months to be returned as 01, 02, etc. This takes precedence over shortMonths if set to YES.
 *  @param showToolbar    set to YES if you want the picker to have a Cancel/Done toolbar.
 *
 *  @return a container view which contains the UIPicker and toolbar
 */
_monthYearPicker = [[LTHMonthYearPickerView alloc] initWithDate: [NSDate date]
																	 shortMonths: NO
												 				 numberedMonths: NO
													 				  andToolbar: YES];
_monthYearPicker.delegate = self;
```

Comes with several delegate methods:
```objc
- (void)pickerDidSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)pickerDidSelectMonth:(NSString *)month;
- (void)pickerDidSelectYear:(NSString *)year;
- (void)pickerDidSelectMonth:(NSString *)month andYear:(NSString *)year;
- (void)pickerDidPressDoneWithMonth:(NSString *)month andYear:(NSString *)year;
- (void)pickerDidPressCancel;
- (void)pickerDidPressCancelWithInitialValues:(NSDictionary *)initialValues;
// Or corresponding notifications; if you prefer it like that, just uncomment the notification posts.
```

Everything is easily customizable with macros and constants, from month & year fonts and colors (individually) to the month names, if you need them in another language (control was created long ago and I didn't really think of proper localization).

![Screenshot](https://rolandleth.com/images/monthyearpickerview/Screenshot.png)

# Apps using this control
If you're using this control, I'd love hearing from you!

# License
Licensed under MIT. If you'd like (or need) a license without attribution, don't hesitate to [contact me](mailto:roland@rolandleth.com).