//
//  VENDatePickerView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENDatePickerView.h"

@interface VENDatePickerView ()
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, copy) NSDateFormatter *dateFormatter;
@property (nonatomic, copy) NSString *dateString;

@end

static const CGFloat kToolBarHeight = 48;
static const CGFloat kDatePickerHeight = 216;
@implementation VENDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker setMaximumDate:[NSDate date]];
        [datePicker addTarget:self action:@selector(dateValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.pickerView addSubview:datePicker];
        
        _datePicker = datePicker;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.datePicker setDate:[VENEmptyClass isEmptyString:self.date] ? [NSDate date] : [self.dateFormatter dateFromString:self.date] animated:YES];
    self.datePicker.frame = CGRectMake(0, kToolBarHeight, kMainScreenWidth, kDatePickerHeight);
}

#pragma mark - ToolBarButtonClick
- (void)confirmButtonClick {
    if ([VENEmptyClass isEmptyString:self.dateString]) {
        self.dateString = [VENEmptyClass isEmptyString:self.date] ? [self.dateFormatter stringFromDate:[NSDate date]] : self.date;
    }
    
    self.datePickerViewBlock(self.dateString);
    
    [self hidden];
}

#pragma mark - dateValueChanged
- (void)dateValueChanged:(UIDatePicker *)datePicker {
    self.dateString = [self.dateFormatter stringFromDate:datePicker.date];
}

#pragma mark - dateFormatter
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
