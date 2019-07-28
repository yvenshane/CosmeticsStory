//
//  VENProductDetailPageAllCompositionTableViewCell.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/26.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENProductDetailPageAllCompositionModel;

NS_ASSUME_NONNULL_BEGIN

@interface VENProductDetailPageAllCompositionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *safeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;

@property (nonatomic, strong) VENProductDetailPageAllCompositionModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *safeLabelLayoutConstraintWidth;

@end

NS_ASSUME_NONNULL_END
