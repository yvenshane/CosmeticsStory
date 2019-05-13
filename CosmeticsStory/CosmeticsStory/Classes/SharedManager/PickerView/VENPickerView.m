//
//  VENPickerView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENPickerView.h"
@interface VENPickerView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) CALayer *lineLayer;

@end

static const CGFloat kMargin = 10;
static const CGFloat kToolBarHeight = 48;
static const NSTimeInterval kAnimationDuration = 0.3;
@implementation VENPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        UIView *pickerView = [[UIView alloc] init];
        pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:pickerView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = UIColorFromRGB(0x333333);
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [pickerView addSubview:titleLabel];
        
        UIButton *cancelButton = [[UIButton alloc] init];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:COLOR_THEME forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [pickerView addSubview:cancelButton];
        
        UIButton *confirmButton = [[UIButton alloc] init];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:COLOR_THEME forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [pickerView addSubview:confirmButton];
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.backgroundColor = UIColorFromRGB(0xE8E8E8).CGColor;
        [pickerView.layer addSublayer:lineLayer];
        
        _pickerView = pickerView;
        _titleLabel = titleLabel;
        _cancelButton = cancelButton;
        _confirmButton = confirmButton;
        _lineLayer = lineLayer;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.text = self.title;
    self.titleLabel.frame = CGRectMake(kMargin + kToolBarHeight + kMargin, 0, kMainScreenWidth - (kMargin + kToolBarHeight + kMargin) * 2, kToolBarHeight);
    self.cancelButton.frame = CGRectMake(kMargin, 0, kToolBarHeight, kToolBarHeight);
    self.confirmButton.frame = CGRectMake(kMainScreenWidth - kToolBarHeight - kMargin, 0, kToolBarHeight, kToolBarHeight);
    self.lineLayer.frame = CGRectMake(0, kToolBarHeight - 1, kMainScreenWidth, 1);
}

#pragma mark - ToolBarButtonClick
- (void)cancelButtonClick {
    [self hidden];
}

- (void)confirmButtonClick {
    [self hidden];
}

#pragma mark - show&hidden
- (void)show {
    self.pickerView.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, self.viewHeight + kToolBarHeight + (kTabBarHeight - 49));
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.pickerView.frame = CGRectMake(0, kMainScreenHeight - self.viewHeight - kToolBarHeight - (kTabBarHeight - 49), kMainScreenWidth, self.viewHeight + kToolBarHeight + (kTabBarHeight - 49));
    } completion:nil];
}

- (void)hidden {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.pickerView.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, self.viewHeight + kToolBarHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (CGFloat)viewHeight {
    if (!_viewHeight) {
        _viewHeight = 216.0f;
    }
    return _viewHeight;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
