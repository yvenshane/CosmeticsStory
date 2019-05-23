//
//  VENHomePageSearchProductHeaderFooterView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/22.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSearchProductHeaderFooterView.h"
#import "VENChipView.h"

@interface VENHomePageSearchProductHeaderFooterView ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) VENChipView *chipView;

@end

@implementation VENHomePageSearchProductHeaderFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xF8F8F8);
        [self addSubview:lineView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = UIColorFromRGB(0x333333);
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:titleLabel];
        
        VENChipView *chipView = [[VENChipView alloc] init];
        [self addSubview:chipView];
        
        _lineView = lineView;
        _titleLabel = titleLabel;
        _chipView = chipView;
    }
    return self;
}

- (void)setChipArr:(NSArray *)chipArr {
    _chipArr = chipArr;
    
    self.chipView.chipArr = chipArr;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.text = self.title;
    
    self.lineView.frame = CGRectMake(0, 0, kMainScreenWidth, 10);
    self.titleLabel.frame = CGRectMake(15, 13.5 + 10, kMainScreenWidth - 30, 17);
    self.chipView.frame = CGRectMake(0, 13.5 + 10 + 17 + 13.5, kMainScreenWidth, self.chipView.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
