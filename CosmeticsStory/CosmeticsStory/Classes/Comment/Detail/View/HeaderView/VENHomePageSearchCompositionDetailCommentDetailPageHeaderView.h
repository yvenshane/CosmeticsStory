//
//  VENHomePageSearchCompositionDetailCommentDetailPageHeaderView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/17.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENHomePageSearchCompositionDetailsPageCommentModel;

NS_ASSUME_NONNULL_BEGIN

@interface VENHomePageSearchCompositionDetailCommentDetailPageHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabelLayoutConstraint;

@property (nonatomic, copy) VENHomePageSearchCompositionDetailsPageCommentModel *model;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
