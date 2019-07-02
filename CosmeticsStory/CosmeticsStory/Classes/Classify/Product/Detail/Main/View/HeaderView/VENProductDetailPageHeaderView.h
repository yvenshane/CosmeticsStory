//
//  VENProductDetailPageHeaderView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/19.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENProductDetailModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^headerViewBlock)(NSInteger);
@interface VENProductDetailPageHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *enNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView2;
@property (weak, nonatomic) IBOutlet UIButton *urlButton;

@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;

@property (nonatomic, strong) VENProductDetailModel *model;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) headerViewBlock headerViewBlock;

@property (weak, nonatomic) IBOutlet UIView *urlImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonLayoutConstraintTop;

@end

NS_ASSUME_NONNULL_END
