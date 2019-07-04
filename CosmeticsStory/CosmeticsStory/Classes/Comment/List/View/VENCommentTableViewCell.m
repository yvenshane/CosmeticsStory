//
//  VENCommentTableViewCell.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/29.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENCommentTableViewCell.h"
#import "VENHomePageSearchCompositionDetailsPageCommentModel.h"

@implementation VENCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(VENHomePageSearchCompositionDetailsPageCommentModel *)model {
    _model = model;
    
    ViewBorderRadius(self.iconImageView, 20.0f, 1, UIColorFromRGB(0xF5F5F5));
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    self.nameLabel.text = model.name;
    self.descriptionLabel.text = model.userSkin;
    self.goodButton.selected = [model.userPraise integerValue] == 0 ? NO : YES;
    [self.goodButton setTitle:[NSString stringWithFormat:@"  %@", model.praiseCount] forState:UIControlStateNormal];
    self.contentLabel.text = model.content;
    
    // 有图片 有回复
    if (![VENEmptyClass isEmptyArray:model.images] && ![VENEmptyClass isEmptyArray:model.list]) {
        
        self.pictureView.hidden = NO;
        
        for (UIView *subview in self.pictureView.subviews) {
            [subview removeFromSuperview];
        }
        
        for (NSInteger i = 0; i < model.images.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 80 + i * 10, 0, 80, 80)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.images[i]]];
            [self.pictureView addSubview:imageView];
        }
        
        self.replyView.hidden = NO;
        
        NSArray *tempArr = [NSArray yy_modelArrayWithClass:[VENHomePageSearchCompositionDetailsPageCommentModel class] json:model.list];
        VENHomePageSearchCompositionDetailsPageCommentModel *model2 = tempArr[0];
        
        
        NSString *contentStr = @"";
        if ([model.secondLevelTotal integerValue] > 1) {
            contentStr = [NSString stringWithFormat:@"%@：%@\n\n查看全部%@条回复", model2.name, model2.content, model.secondLevelTotal];
        } else {
            contentStr = [NSString stringWithFormat:@"%@：%@", model2.name, model2.content];
        }
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_THEME range:(NSMakeRange(0, model2.name.length))];
        
        if ([model.secondLevelTotal integerValue] > 1) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_THEME range:(NSMakeRange(contentStr.length - 7 - model.secondLevelTotal.length, 7 + model.secondLevelTotal.length))];
        }
        
        self.replyLabel.attributedText = attributedString;
        
        self.replyViewTopLayoutConstraint.constant = 106.0f;
        self.dateLabelTopLayoutConstraint.constant = 106.0f + [self.replyLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 70 - 15, CGFLOAT_MAX)].height + 20.0f + 8.0f;
        
        // 有图片 没回复
    } else if (![VENEmptyClass isEmptyArray:model.images] && [VENEmptyClass isEmptyArray:model.list]) {
        
        self.pictureView.hidden = NO;
        
        for (UIView *subview in self.pictureView.subviews) {
            [subview removeFromSuperview];
        }
        
        for (NSInteger i = 0; i < model.images.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 80 + i * 10, 0, 80, 80)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.images[i]]];
            [self.pictureView addSubview:imageView];
        }
        
        self.replyView.hidden = YES;
        
        self.replyViewTopLayoutConstraint.constant = 0.0f;
        self.dateLabelTopLayoutConstraint.constant = 13.0f + 80.0f + 8.0f;
        
        // 没图片 有回复
    } else if ([VENEmptyClass isEmptyArray:model.images] && ![VENEmptyClass isEmptyArray:model.list]) {
        
        self.pictureView.hidden = YES;
        
        self.replyView.hidden = NO;
        
        NSArray *tempArr = [NSArray yy_modelArrayWithClass:[VENHomePageSearchCompositionDetailsPageCommentModel class] json:model.list];
        VENHomePageSearchCompositionDetailsPageCommentModel *model2 = tempArr[0];
        
        NSString *contentStr = @"";
        if ([model.secondLevelTotal integerValue] > 1) {
            contentStr = [NSString stringWithFormat:@"%@：%@\n\n查看全部%@条回复", model2.name, model2.content, model.secondLevelTotal];
        } else {
            contentStr = [NSString stringWithFormat:@"%@：%@", model2.name, model2.content];
        }
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_THEME range:(NSMakeRange(0, model2.name.length))];
        
        if ([model.secondLevelTotal integerValue] > 1) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_THEME range:(NSMakeRange(contentStr.length - 7 - model.secondLevelTotal.length, 7 + model.secondLevelTotal.length))];
        }
        
        self.replyLabel.attributedText = attributedString;
        
        self.replyViewTopLayoutConstraint.constant = 13.0f;
        self.dateLabelTopLayoutConstraint.constant = 13.0f + [self.replyLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 70 - 15, CGFLOAT_MAX)].height + 20.0f + 8.0f;
        
        // 没图片 没回复
    } else {
        
        self.pictureView.hidden = YES;
        self.replyView.hidden = YES;
        
        self.replyViewTopLayoutConstraint.constant = 0.0f;
        self.dateLabelTopLayoutConstraint.constant = 8.0f;
    }
    
    self.dateLabel.text = model.addtime;
}

@end
