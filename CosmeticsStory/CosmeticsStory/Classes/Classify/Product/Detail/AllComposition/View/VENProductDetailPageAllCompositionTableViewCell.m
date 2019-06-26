//
//  VENProductDetailPageAllCompositionTableViewCell.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/26.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENProductDetailPageAllCompositionTableViewCell.h"
#import "VENProductDetailPageAllCompositionModel.h"

@implementation VENProductDetailPageAllCompositionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(VENProductDetailPageAllCompositionModel *)model {
    _model = model;
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.name_ch];
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, model.name_ch.length)];
    [self.nameButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    ViewRadius(self.safeLabel, 9);
    
    self.safeLabel.text = model.safety_factor;
    if ([model.safety_factor integerValue] < 3) {
        self.safeLabel.backgroundColor = UIColorFromRGB(0x56B864);
    } else if ([model.safety_factor integerValue] > 2 && [model.safety_factor integerValue] < 7) {
        self.safeLabel.backgroundColor = UIColorFromRGB(0xF7AB59);
    } else {
        self.safeLabel.backgroundColor = UIColorFromRGB(0xC03232);
    }
    
    self.imageView1.hidden = [model.active_ingredients integerValue] == 0 ? YES : NO;
    self.imageView2.hidden = [model.acne integerValue] == 0 ? YES : NO;
    
    self.otherLabel.text = model.objective;
}

@end
