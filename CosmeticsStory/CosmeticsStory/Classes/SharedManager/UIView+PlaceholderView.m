//
//  UIView+PlaceholderView.m
//
//  Created by YVEN.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "UIView+PlaceholderView.h"
#import <objc/runtime.h>

@implementation UIView (PlaceholderView)

static void *placeholderViewKey = &placeholderViewKey;
static void *originalScrollEnabledKey = &originalScrollEnabledKey;

- (UIView *)placeholderView {
    return objc_getAssociatedObject(self, &placeholderViewKey);
}

- (void)setPlaceholderView:(UIView *)placeholderView {
    objc_setAssociatedObject(self, &placeholderViewKey, placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showPlaceholderViewWithType:(VENPlaceholderViewType)type {
    
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        scrollView.scrollEnabled = NO;
    }
    
    if (self.placeholderView) {
        [self.placeholderView removeFromSuperview];
        self.placeholderView = nil;
    }
    
    self.placeholderView = [[UIView alloc] init];
    self.placeholderView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.placeholderView];
    
    [self.placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(self);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.placeholderView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView.superview);
        make.top.mas_equalTo(62);
        make.size.mas_equalTo(CGSizeMake(116, 93));
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.numberOfLines = 0;
    descLabel.textColor = UIColorFromRGB(0xFF9400);
    descLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.placeholderView addSubview:descLabel];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(descLabel.superview);
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(20);
    }];
    
    UILabel *descLabel2 = [[UILabel alloc] init];
    descLabel2.textAlignment = NSTextAlignmentCenter;
    descLabel2.numberOfLines = 0;
    descLabel2.textColor = UIColorFromRGB(0x999999);
    descLabel2.font = [UIFont systemFontOfSize:14.0f];
    [self.placeholderView addSubview:descLabel2];
    
    [descLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(descLabel.superview);
        make.top.mas_equalTo(descLabel.mas_bottom).mas_offset(33);
    }];
    
    switch (type) {
        case VENPlaceholderViewTypeNoData:
        {
            imageView.image = [UIImage imageNamed:@"icon_noData"];
            descLabel.text = @"对不起，没有搜索到您要的结果。";
            descLabel2.text = @"乐鱼美妆建议您：\n\n1、检查下搜索名称是否正确\n2、更换或减少搜索的筛选条件";
        }
            break;
            
        default:
            break;
    }
}

- (void)removePlaceholderView {
    if (self.placeholderView) {
        [self.placeholderView removeFromSuperview];
        self.placeholderView = nil;
    }
    
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        scrollView.scrollEnabled = YES;
    }
}

@end
