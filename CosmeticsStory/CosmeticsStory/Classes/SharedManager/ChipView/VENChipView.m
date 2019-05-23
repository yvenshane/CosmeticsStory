//
//  VENChipView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/22.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENChipView.h"

@implementation VENChipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    
    return self;
}

- (void)setChipArr:(NSArray *)chipArr {
    _chipArr = chipArr;
    
    CGFloat x = 15;
    CGFloat y = 0;
    
    for (NSInteger i = 0; i < chipArr.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [button setTitle:chipArr[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        ViewRadius(button, 15.0f);
        [self addSubview:button];
        
        CGFloat height = 30;
        CGFloat width = [button sizeThatFits:CGSizeMake(CGFLOAT_MAX, height)].width + 30;
        
        // 超长标签
        if (width > kMainScreenWidth - 30) {
            width = kMainScreenWidth - 30;
            [button setTitle:[NSString stringWithFormat:@"    %@", chipArr[i]] forState:UIControlStateNormal];
        }
        
        if (x + width + 15 > kMainScreenWidth) {
            x = 15;
            y += height + 10;
        }
        
        button.frame = CGRectMake(x, y, width, height);
        x += width + 10;
    }
    
    self.height = y + 30 + 23;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
