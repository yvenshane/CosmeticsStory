//
//  VENChangePhoneNumberTableViewCell.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/13.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENChangePhoneNumberTableViewCell.h"

@implementation VENChangePhoneNumberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    ViewBorderRadius(self.getVerificationCodeButton, 3.0f, 1.0f, COLOR_THEME);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
