//
//  VENCommentTableViewCell.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/29.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENHomePageSearchCompositionDetailsPageCommentModel;

NS_ASSUME_NONNULL_BEGIN

@interface VENCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyViewTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabelTopLayoutConstraint;

@property (nonatomic, strong) VENHomePageSearchCompositionDetailsPageCommentModel *model;

@end

NS_ASSUME_NONNULL_END
