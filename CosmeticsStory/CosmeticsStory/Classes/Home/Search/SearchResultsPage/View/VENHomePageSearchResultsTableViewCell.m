//
//  VENHomePageSearchResultsTableViewCell.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/27.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSearchResultsTableViewCell.h"
#import "VENHomePageSearchResultsModel.h"

@implementation VENHomePageSearchResultsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(VENHomePageSearchResultsModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
    self.titleLabel.text = model.goods_name;
    self.numberLabel.text = model.refraction;
    self.priceLabel.text = [NSString stringWithFormat:@"参考价：¥%@/%@", model.price, model.capacity];
    [self showStarsWithNumber:model.refraction];
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
