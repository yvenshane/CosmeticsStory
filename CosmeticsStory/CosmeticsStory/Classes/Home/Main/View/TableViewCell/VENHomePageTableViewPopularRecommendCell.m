//
//  VENHomePageTableViewPopularRecommendCell.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/16.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageTableViewPopularRecommendCell.h"
#import "VENHomePageModel.h"

@implementation VENHomePageTableViewPopularRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(VENHomePageModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb] placeholderImage:[UIImage imageNamed:@"icon_large"]];
    self.titleLabel.text = model.goods_name;
    self.numberLabel.text = model.refraction;
    self.priceLabel.text = [NSString stringWithFormat:@"参考价：¥%@/%@", model.price, model.capacity];
    
    [self showStarsWithNumber:model.refraction];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showStarsWithNumber:(NSString *)number {
    
    for (UIView *subview in self.starView.subviews) {
        [subview removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < [number integerValue]; i++) {
        if (i < 5) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (12 + 6), 0, 12, 12)];
            imageView.image = [UIImage imageNamed:@"icon_star4"];
            [self.starView addSubview:imageView];
        }
    }
    
    CGFloat number2 = [number floatValue] - [number integerValue];
    
    if (number2 > 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(([number integerValue]) * (12 + 6), 0, 12, 12)];
        imageView.image = [UIImage imageNamed:@"icon_star3"];
        [self.starView addSubview:imageView];
    }
}

@end
