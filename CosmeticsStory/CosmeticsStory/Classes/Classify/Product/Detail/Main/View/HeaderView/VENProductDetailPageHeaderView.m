//
//  VENProductDetailPageHeaderView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/19.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENProductDetailPageHeaderView.h"
#import "VENProductDetailModel.h"

@implementation VENProductDetailPageHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setModel:(VENProductDetailModel *)model {
    _model = model;
    
    
    self.iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewClick)];
    [self.iconImageView addGestureRecognizer:tap];
    
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image]];
    self.nameLabel.text = model.goods_name_ch;
    self.enNameLabel.text = [NSString stringWithFormat:@"英文名称：%@", model.goods_name_en];
    self.priceLabel.text = [NSString stringWithFormat:@"参考价：%@", model.price];
    [self showStarsWithNumber:model.fraction];
    self.numberLabel.text = model.fraction;
    [self showChipsWithArray:model.label_purpose];
    
    [self.iconImageView2 sd_setImageWithURL:[NSURL URLWithString:model.url_image]];
    
    self.buttonOne.tag = 1;
    self.buttonTwo.tag = 2;
    self.buttonThree.tag = 3;
}

- (void)setType:(NSInteger)type {
    _type = type;
    
    if (type == 1) {
        self.buttonOne.selected = YES;
        self.buttonTwo.selected = NO;
        self.buttonThree.selected = NO;
    } else if (type == 2) {
        self.buttonOne.selected = NO;
        self.buttonTwo.selected = YES;
        self.buttonThree.selected = NO;
    } else {
        self.buttonOne.selected = NO;
        self.buttonTwo.selected = NO;
        self.buttonThree.selected = YES;
    }
}

- (void)showStarsWithNumber:(NSString *)number {
    
    for (UIView *subview in self.starView.subviews) {
        [subview removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < [number integerValue]; i++) {
        if (i < 5) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (12 + 6), 0, 12, 12)];
            imageView.image = [UIImage imageNamed:@"icon_star4"];
            [self.starView addSubview:imageView];
        }
    }
    
    for (NSInteger i = 0; i < 5 - [number integerValue]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i + [number integerValue]) * (12 + 6), 0, 12, 12)];
        imageView.image = [UIImage imageNamed:@"icon_star5"];
        [self.starView addSubview:imageView];
    }
}

- (void)showChipsWithArray:(NSArray *)arr {
    
    CGFloat x = 130;
    for (NSString *str in arr) {
        UILabel *label = [[UILabel alloc] init];
        label.text = str;
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        
        CGFloat width = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, 24.0f)].width;
        label.frame = CGRectMake(x, 125, width + 24, 24.0f);
        
        ViewBorderRadius(label, 4.0f, 1.0f, UIColorFromRGB(0xE8E8E8));
        
        x += width + 24 + 10;
        
        if (x > kMainScreenWidth) {
            return;
        }
        
        [self addSubview:label];
    }
}

- (IBAction)buttonClick:(UIButton *)button {
    self.headerViewBlock(button.tag);
}

#pragma mark - 图片点击放大
- (void)iconImageViewClick {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIButton *backgroundButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    backgroundButton.backgroundColor = [UIColor blackColor];
    [backgroundButton addTarget:self action:@selector(backgroundButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:backgroundButton];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    [backgroundImageView sd_setImageWithURL:[NSURL URLWithString:self.model.goods_image]];
    [backgroundButton addSubview:backgroundImageView];
    
    CGFloat imageWidth = backgroundImageView.image.size.width;
    CGFloat imageHeight = backgroundImageView.image.size.height;
    
    if (imageWidth > kMainScreenWidth) {
        imageHeight = imageHeight * kMainScreenWidth / imageWidth;
        imageWidth = kMainScreenWidth;
    } else if (imageWidth < kMainScreenWidth) {
        
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
