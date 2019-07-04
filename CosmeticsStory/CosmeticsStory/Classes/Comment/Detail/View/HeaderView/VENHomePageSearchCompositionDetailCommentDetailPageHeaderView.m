//
//  VENHomePageSearchCompositionDetailCommentDetailPageHeaderView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/17.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSearchCompositionDetailCommentDetailPageHeaderView.h"
#import "VENHomePageSearchCompositionDetailsPageCommentModel.h"

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
    
    ViewBorderRadius(self.iconImageView, 20.0f, 1, UIColorFromRGB(0xF5F5F5));
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
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
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * 80 + i * 10, 0, 80, 80)];
            [button sd_setImageWithURL:[NSURL URLWithString:model.images[i]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.pictureView addSubview:button];
        }
    }
    
    self.dateLabel.text = model.addtime;
}

#pragma mark - 图片点击放大
- (void)buttonClick:(UIButton *)button {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIButton *backgroundButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    backgroundButton.backgroundColor = [UIColor blackColor];
    [backgroundButton addTarget:self action:@selector(backgroundButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:backgroundButton];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = button.imageView.image;
    [backgroundButton addSubview:backgroundImageView];
    
    CGFloat imageWidth = backgroundImageView.image.size.width;
    CGFloat imageHeight = backgroundImageView.image.size.height;
    
    if (imageWidth > kMainScreenWidth) {
        imageHeight = imageHeight * kMainScreenWidth / imageWidth;
        imageWidth = kMainScreenWidth;
    }
    
    backgroundImageView.frame = CGRectMake(kMainScreenWidth / 2 - imageWidth / 2, kMainScreenHeight / 2 - imageHeight / 2, imageWidth, imageHeight);
    
    [self shakeToShow:backgroundButton];
}

- (void)shakeToShow:(UIView*)aView {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.1;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (void)backgroundButtonClick:(UIButton *)button {
    [button removeFromSuperview];
}

@end
