//
//  VENHomePageSearchCompositionDetailsPageTableHeaderView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/29.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSearchCompositionDetailsPageTableHeaderView.h"
#import "VENHomePageSearchCompositionDetailsPageModel.h"

@implementation VENHomePageSearchCompositionDetailsPageTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setModel:(VENHomePageSearchCompositionDetailsPageModel *)model {
    _model = model;
    
    self.titleLabel.text = model.name;
    self.enNameLabel.text = [NSString stringWithFormat:@"英文名(INCI)：%@", model.name_en];
    self.otherNameLabel.text = [NSString stringWithFormat:@"别名：%@", model.name_ch];
    self.casLabel.text = [NSString stringWithFormat:@"CAS号：%@", model.cas];
    
    self.compositionLabel.text = model.active_ingredients_name;
    self.iconImageView.image = [UIImage imageNamed:[model.acne integerValue] == 0 ? @"icon_112962" : @"icon_112963"];
    self.boolLabel.text = model.limit;
    
    [self showChipsWithArray:model.label];
    
    self.descriptionLabel.text = model.explain;
    
    
    if (!self.moreButton.selected) {
        CGFloat height = [self.descriptionLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 30, CGFLOAT_MAX)].height;
        if (height > 140) {
            self.moreButtonLayoutConstraintHeight.constant = 57.0f;
            [self.moreButton setTitle:@"更多" forState:UIControlStateNormal];
            self.moreButton.userInteractionEnabled = YES;
        } else {
            self.moreButtonLayoutConstraintHeight.constant = 20.0f;
            [self.moreButton setTitle:@"" forState:UIControlStateNormal];
            self.moreButton.userInteractionEnabled = NO;
        }
    } else {
        self.descriptionLabel.numberOfLines = 0;
        [self.moreButton setTitle:@"" forState:UIControlStateSelected];
        self.moreButton.userInteractionEnabled = NO;
        self.moreButtonLayoutConstraintHeight.constant = 20.0f;
    }
    
    
    if ([model.safety_factor isEqualToString:@"10"]) {
        [self showStarsWithNumber:@"0.5"];
    } else if ([model.safety_factor isEqualToString:@"9"]) {
        [self showStarsWithNumber:@"1"];
    } else if ([model.safety_factor isEqualToString:@"8"]) {
        [self showStarsWithNumber:@"1.5"];
    } else if ([model.safety_factor isEqualToString:@"7"]) {
        [self showStarsWithNumber:@"2"];
    } else if ([model.safety_factor isEqualToString:@"6"]) {
        [self showStarsWithNumber:@"2.5"];
    } else if ([model.safety_factor isEqualToString:@"5"]) {
        [self showStarsWithNumber:@"3"];
    } else if ([model.safety_factor isEqualToString:@"4"]) {
        [self showStarsWithNumber:@"3.5"];
    } else if ([model.safety_factor isEqualToString:@"3"]) {
        [self showStarsWithNumber:@"4"];
    } else if ([model.safety_factor isEqualToString:@"2"]) {
        [self showStarsWithNumber:@"4.5"];
    } else {
        [self showStarsWithNumber:@"5"];
    }
    
    self.commentLabel.text = [NSString stringWithFormat:@"评论（%@）", model.commentNumber];
}

- (void)showChipsWithArray:(NSArray *)arr {
    
    CGFloat x = 15;
    for (NSString *str in arr) {
        UILabel *label = [[UILabel alloc] init];
        label.text = str;
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        
        CGFloat width = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, 24.0f)].width;
        label.frame = CGRectMake(x, 0, width + 24, 24.0f);
        
        ViewBorderRadius(label, 4.0f, 1.0f, UIColorFromRGB(0xE8E8E8));
        
        x += width + 24 + 10;
        
        if (x > kMainScreenWidth) {
            return;
        }
        
        [self.labelView addSubview:label];
    }
}

- (void)showStarsWithNumber:(NSString *)number {
    
    for (UIView *subview in self.starView.subviews) {
        [subview removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < [number integerValue]; i++) {
        if (i < 5) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (12 + 6), 0, 12, 12)];
            imageView.image = [UIImage imageNamed:@"icon_star2"];
            [self.starView addSubview:imageView];
        }
    }
    
    if ([number floatValue] <= 5) {
        if ([number floatValue] > [[NSString stringWithFormat:@"%ld", (long)[number integerValue]] floatValue]) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([number integerValue] * (12 + 6), 0, 12, 12)];
            imageView.image = [UIImage imageNamed:@"icon_star1"];
            [self.starView addSubview:imageView];
        }
    }
    
    if ([number containsString:@".5"]) {
        for (NSInteger i = 0; i < 5 - [number integerValue] - 1; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i + [number integerValue] + 1) * (12 + 6), 0, 12, 12)];
            imageView.image = [UIImage imageNamed:@"icon_star5"];
            [self.starView addSubview:imageView];
        }
    } else {
        for (NSInteger i = 0; i < 5 - [number integerValue]; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i + [number integerValue]) * (12 + 6), 0, 12, 12)];
            imageView.image = [UIImage imageNamed:@"icon_star5"];
            [self.starView addSubview:imageView];
        }
    }
    
}
@end
