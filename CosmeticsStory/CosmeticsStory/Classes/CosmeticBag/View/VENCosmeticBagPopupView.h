//
//  VENCosmeticBagPopupView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/24.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENCosmeticBagPopupView : UIView
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSMutableArray *contentMuArr;
@property (nonatomic, strong) NSString *ingredients_id;

@end

NS_ASSUME_NONNULL_END
