//
//  VENHomePageSearchResultsTableViewCell.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/27.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENHomePageSearchResultsModel;

NS_ASSUME_NONNULL_BEGIN

@interface VENHomePageSearchResultsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) VENHomePageSearchResultsModel *model;

@end

NS_ASSUME_NONNULL_END
