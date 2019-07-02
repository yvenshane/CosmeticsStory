//
//  VENHomePageSearchCompositionTableViewCell.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/23.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSearchCompositionTableViewCell.h"
#import "VENHomePageSearchCompositionModel.h"

@implementation VENHomePageSearchCompositionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(VENHomePageSearchCompositionModel *)model {
    _model = model;
    
    self.titleLabel.text = model.name;
    
    if ([model.acne integerValue] == 0) {
        self.iconImageView.image = [UIImage imageNamed:@"icon_112962"];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"icon_112963"];
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
