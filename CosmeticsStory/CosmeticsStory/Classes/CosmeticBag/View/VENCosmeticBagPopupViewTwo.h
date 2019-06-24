//
//  VENCosmeticBagPopupViewTwo.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/24.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^cosmeticBagPopupViewTwoBlock)(NSString *);
@interface VENCosmeticBagPopupViewTwo : UIView
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, copy) cosmeticBagPopupViewTwoBlock cosmeticBagPopupViewTwoBlock;

@end

NS_ASSUME_NONNULL_END
