//
//  VENMineTableHeaderView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/9.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMineTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *zujiButton;
@property (weak, nonatomic) IBOutlet UIButton *xiaoxiButton;
@property (weak, nonatomic) IBOutlet UIButton *ziliaoButton;
@property (weak, nonatomic) IBOutlet UIButton *shezhiButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

NS_ASSUME_NONNULL_END
