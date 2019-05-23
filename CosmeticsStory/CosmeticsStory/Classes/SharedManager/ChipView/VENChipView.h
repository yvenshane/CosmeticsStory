//
//  VENChipView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/22.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^chipViewBlock)(CGFloat);
@interface VENChipView : UIView
@property (nonatomic, copy) NSArray *chipArr;
@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
