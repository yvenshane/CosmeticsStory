//
//  VENFootprintCommentTableViewCell.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/25.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENFootprintCommentModel;

NS_ASSUME_NONNULL_BEGIN

@interface VENFootprintCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *addImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundViewLayoutConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLayoutConstranitLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelLayoutConstranitBottom;
@property (weak, nonatomic) IBOutlet UIButton *goodsButton;

@property (nonatomic, assign) BOOL isProduct;
@property (nonatomic, strong) VENFootprintCommentModel *model;

@end

NS_ASSUME_NONNULL_END
