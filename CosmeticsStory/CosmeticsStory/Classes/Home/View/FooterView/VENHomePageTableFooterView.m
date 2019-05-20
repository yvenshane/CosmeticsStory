//
//  VENHomePageTableFooterView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/17.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageTableFooterView.h"
#import "VENWaterfallFlowView.h"

@interface VENHomePageTableFooterView ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView2;
@property (nonatomic, strong) VENWaterfallFlowView *waterfallFlowView;

@end

@implementation VENHomePageTableFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xF8F8F8);
        [self addSubview:lineView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"发现";
        titleLabel.textColor = UIColorFromRGB(0x333333);
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [self addSubview:titleLabel];
        
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = UIColorFromRGB(0xF8F8F8);
        [self addSubview:lineView2];
        
        VENWaterfallFlowView *waterfallFlowView = [[VENWaterfallFlowView alloc] init];
        [self addSubview:waterfallFlowView];
        
        _lineView = lineView;
        _titleLabel = titleLabel;
        _lineView2 = lineView2;
        _waterfallFlowView = waterfallFlowView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.lineView.frame = CGRectMake(0, 0, kMainScreenWidth, 10);
    self.titleLabel.frame = CGRectMake(15, 10, kMainScreenWidth - 30, 65);
    self.lineView2.frame = CGRectMake(0, 75, kMainScreenWidth, 10);
    self.waterfallFlowView.frame = CGRectMake(0, 86, kMainScreenWidth, 500);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
