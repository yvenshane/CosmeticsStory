//
//  VENHomePageBannerCollectionViewCell.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/15.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageBannerCollectionViewCell.h"

@implementation VENHomePageBannerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bannerImageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    ViewRadius(self.bannerImageView, 5.0f);
}

@end
