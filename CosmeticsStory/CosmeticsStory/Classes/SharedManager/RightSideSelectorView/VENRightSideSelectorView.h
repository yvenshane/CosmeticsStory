//
//  VENRightSideSelectorView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/7/23.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^rightSideSelectorViewBlock)(NSArray *);
@interface VENRightSideSelectorView : UIView
@property (nonatomic, copy) NSDictionary *dataSource;
@property (nonatomic, copy) NSString *comprehensive;
@property (nonatomic, copy) NSString *purpose;
@property (nonatomic, copy) NSString *effect;
@property (nonatomic, copy) NSString *price;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, copy) rightSideSelectorViewBlock rightSideSelectorViewBlock;

@end

NS_ASSUME_NONNULL_END
