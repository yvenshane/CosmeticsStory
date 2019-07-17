//
//  VENFootprintCommentTableViewCell.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/25.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENFootprintCommentTableViewCell.h"
#import "VENFootprintCommentModel.h"

@implementation VENFootprintCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(VENFootprintCommentModel *)model {
    _model = model;
    
    if (self.isProduct) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
        self.titleLabel.text = model.goods_name;
        
        self.iconImageView.hidden = NO;
        self.backgroundViewLayoutConstraintHeight.constant = 70;
        self.titleLabelLayoutConstranitLeft.constant = 75;
    } else {
        
        self.titleLabel.text = model.ingredients_name;
        
        self.iconImageView.hidden = YES;
        self.backgroundViewLayoutConstraintHeight.constant = 40;
        self.titleLabelLayoutConstranitLeft.constant = 10;
    }
    
    
    self.dateLabel.text = model.addtime;
    self.contentLabel.text = model.content;
    
    for (UIView *subview in self.addImageView.subviews) {
        [subview removeFromSuperview];
    }
    if (model.images.count > 0) {
        self.addImageView.hidden = NO;
        self.contentLabelLayoutConstranitBottom.constant = 79;
        
        for (NSInteger i = 0; i < model.images.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 60 + i * 10, 0, 60, 60)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.images[i]]];
            [self.addImageView addSubview:imageView];
        }
    } else {
        self.addImageView.hidden = YES;
        self.contentLabelLayoutConstranitBottom.constant = 9;
    }
}

@end
