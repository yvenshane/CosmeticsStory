//
//  VENHomePageSearchCompositionTableViewCell.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/23.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENHomePageSearchCompositionModel;

NS_ASSUME_NONNULL_BEGIN

@interface VENHomePageSearchCompositionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) VENHomePageSearchCompositionModel *model;

@end

NS_ASSUME_NONNULL_END
