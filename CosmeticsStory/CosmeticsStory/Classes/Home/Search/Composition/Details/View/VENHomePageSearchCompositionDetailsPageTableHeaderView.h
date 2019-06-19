//
//  VENHomePageSearchCompositionDetailsPageTableHeaderView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/29.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENHomePageSearchCompositionDetailsPageModel;

NS_ASSUME_NONNULL_BEGIN

@interface VENHomePageSearchCompositionDetailsPageTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *enNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *casLabel;
@property (weak, nonatomic) IBOutlet UIView *starsView;
@property (weak, nonatomic) IBOutlet UILabel *compositionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *boolLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, strong) VENHomePageSearchCompositionDetailsPageModel *model;

@end

NS_ASSUME_NONNULL_END
