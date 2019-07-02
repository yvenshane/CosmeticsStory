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
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
    self.titleLabel.text = model.goods_name;
    self.numberLabel.text = model.fraction;
    self.priceLabel.text = [NSString stringWithFormat:@"参考价：%@", model.price];
    
    [self showStarsWithNumber:model.fraction];
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
    
    for (NSInteger i = 0; i < 5 - [number integerValue]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i + [number integerValue]) * (12 + 6), 0, 12, 12)];
        imageView.image = [UIImage imageNamed:@"icon_star5"];
        [self.starView addSubview:imageView];
    }
}

@end
