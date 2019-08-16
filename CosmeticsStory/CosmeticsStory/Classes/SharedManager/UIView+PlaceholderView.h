//
//  UIView+PlaceholderView.h
//
//  Created by YVEN.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VENPlaceholderViewType) {
    VENPlaceholderViewTypeNoData
};
@interface UIView (PlaceholderView)
@property (nonatomic, strong) UIView *placeholderView;

- (void)showPlaceholderViewWithType:(VENPlaceholderViewType)type;
- (void)removePlaceholderView;

@end
