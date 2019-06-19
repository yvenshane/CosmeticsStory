//
//  VENHomePageSearchCompositionDetailCommentDetailPageHeaderView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/17.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSearchCompositionDetailCommentDetailPageHeaderView.h"
#import "VENHomePageSearchCompositionDetailsPageCommentModel.h"

@interface VENHomePageSearchCompositionDetailCommentDetailPageHeaderView ()
@property (nonatomic, copy) NSString *id;

@end

@implementation VENHomePageSearchCompositionDetailCommentDetailPageHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setName:(NSString *)name {
    _name = name;
    
    self.titleLabel.text = name;
}

- (void)setModel:(VENHomePageSearchCompositionDetailsPageCommentModel *)model {
    _model = model;
    
    self.id = model.id;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.nameLabel.text = model.name;
    self.descriptionLabel.text = model.userSkin;
    self.goodButton.selected = [model.userPraise integerValue] == 0 ? NO : YES;
    [self.goodButton setTitle:[NSString stringWithFormat:@"  %@", model.praiseCount] forState:UIControlStateNormal];
    self.contentLabel.text = model.content;

    //    pictureView
    if ([VENEmptyClass isEmptyArray:model.images]) {
        self.pictureView.hidden = YES;
        self.dateLabelLayoutConstraint.constant = -80.0f;
        
    } else {
        self.pictureView.hidden = NO;
        self.dateLabelLayoutConstraint.constant = 8.0f;
        
        for (UIView *subview in self.pictureView.subviews) {
            [subview removeFromSuperview];
        }

        for (NSInteger i = 0; i < model.images.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 80 + i * 10, 0, 80, 80)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.images[i]]];
            [self.pictureView addSubview:imageView];
        }
    }
    
    self.dateLabel.text = model.addtime;
}

- (IBAction)goodButtonClick:(UIButton *)button {
    NSDictionary *parameters = @{@"cid" : self.id,
                                 @"type" : @"2"};
    [[VENApiManager sharedManager] praiseCommentWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
        
        if (button.selected) {
            button.selected = NO;
        } else {
            button.selected = YES;
        }
        
    }];
}


@end
