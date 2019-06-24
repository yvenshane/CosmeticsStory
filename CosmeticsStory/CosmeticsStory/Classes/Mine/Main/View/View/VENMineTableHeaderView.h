//
//  VENMineTableHeaderView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/9.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENDataPageModel;

NS_ASSUME_NONNULL_BEGIN

@interface VENMineTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *footprintButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *dataButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic, strong) VENDataPageModel *model;

@end

NS_ASSUME_NONNULL_END
