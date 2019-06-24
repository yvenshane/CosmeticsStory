//
//  VENMineTableHeaderView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/9.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMineTableHeaderView.h"
#import "VENDataPageModel.h"

@implementation VENMineTableHeaderView

- (void)setModel:(VENDataPageModel *)model {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    self.nameLabel.text = model.name;
    self.phoneLabel.text = [NSString stringWithFormat:@"账号：%@", model.id];
}

- (void)drawRect:(CGRect)rect {
    ViewRadius(self.iconImageView, 30.0f);
}
@end
