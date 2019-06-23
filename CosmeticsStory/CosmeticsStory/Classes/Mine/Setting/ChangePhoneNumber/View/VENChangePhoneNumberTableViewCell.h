//
//  VENChangePhoneNumberTableViewCell.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/13.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENChangePhoneNumberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextFieldRightLayoutConstraint;

@end

NS_ASSUME_NONNULL_END
