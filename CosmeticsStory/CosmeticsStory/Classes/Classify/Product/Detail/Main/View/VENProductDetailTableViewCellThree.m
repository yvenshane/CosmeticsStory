//
//  VENProductDetailTableViewCellThree.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/20.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENProductDetailTableViewCellThree.h"

@implementation VENProductDetailTableViewCellThree

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGoods_brand:(NSDictionary *)goods_brand {
    _goods_brand = goods_brand;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:goods_brand[@"logo"]]];
    self.nameLabel.text = goods_brand[@"name_ch"];
    self.descriptionLabel.text = goods_brand[@"name_en"];
    self.contentLabel.text = goods_brand[@"descriptionn"];
}

@end
