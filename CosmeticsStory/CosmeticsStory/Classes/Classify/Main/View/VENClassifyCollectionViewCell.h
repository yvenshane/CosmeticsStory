//
//  VENClassifyCollectionViewCell.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/9.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENClassifyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bckgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
