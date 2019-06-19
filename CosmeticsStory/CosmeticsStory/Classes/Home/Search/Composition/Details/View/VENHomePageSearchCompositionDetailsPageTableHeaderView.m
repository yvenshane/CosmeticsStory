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
    
    [self showStarsWithNumber:model.safety_factor];
    self.compositionLabel.text = model.active_ingredients_name;
    self.iconImageView.image = [UIImage imageNamed:[model.acne integerValue] == 0 ? @"icon_112962" : @"icon_112963"];
    self.boolLabel.text = model.limit;
    
    [self showChipsWithArray:model.label];
    
    self.descriptionLabel.text = model.explain;
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
        label.frame = CGRectMake(x, 231, width + 24, 24.0f);
        
        ViewBorderRadius(label, 4.0f, 1.0f, UIColorFromRGB(0xE8E8E8));
        
        x += width + 24 + 10;
        
        if (x > kMainScreenWidth) {
            return;
        }
        
        [self addSubview:label];
    }
}

- (void)showStarsWithNumber:(NSString *)number {
    
    for (UIView *subview in self.starsView.subviews) {
        [subview removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < [number integerValue]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (12 + 6), 0, 12, 12)];
        imageView.image = [UIImage imageNamed:@"icon_star2"];
        [self.starsView addSubview:imageView];
    }
    
    if ([number floatValue] > [[NSString stringWithFormat:@"%ld", (long)[number integerValue]] floatValue]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([number integerValue] * (12 + 6), 0, 12, 12)];
        imageView.image = [UIImage imageNamed:@"icon_star1"];
        [self.starsView addSubview:imageView];
    }
}

@end
