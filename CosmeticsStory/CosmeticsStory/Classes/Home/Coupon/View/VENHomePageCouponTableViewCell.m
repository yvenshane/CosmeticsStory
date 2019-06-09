//
//  VENHomePageCouponTableViewCell.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/6.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageCouponTableViewCell.h"

@implementation VENHomePageCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    ViewRadius(self.backgroundVieww, 4.0f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
