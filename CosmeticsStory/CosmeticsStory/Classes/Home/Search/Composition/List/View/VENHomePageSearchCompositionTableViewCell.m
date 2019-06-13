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
    [self showStarsWithNumber:model.safety_factor];
    if ([model.acne integerValue] == 0) {
        self.iconImageView.image = [UIImage imageNamed:@"icon_112962"];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"icon_112963"];
    }
}

- (void)showStarsWithNumber:(NSString *)number {
    
    for (UIView *subview in self.starView.subviews) {
        [subview removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < [number integerValue]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (12 + 6), 0, 12, 12)];
        imageView.image = [UIImage imageNamed:@"icon_star4"];
        [self.starView addSubview:imageView];
    }
    
    if ([number floatValue] > [[NSString stringWithFormat:@"%ld", (long)[number integerValue]] floatValue]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([number integerValue] * (12 + 6), 0, 12, 12)];
        imageView.image = [UIImage imageNamed:@"icon_star3"];
        [self.starView addSubview:imageView];
    }
}


@end
