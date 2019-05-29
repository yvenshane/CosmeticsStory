//
//  VENHomePageSearchProductHeaderFooterView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/22.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^headerFooterViewDeleteBlock)(NSString *);
@interface VENHomePageSearchProductHeaderFooterView : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *chipArr;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, copy) headerFooterViewDeleteBlock headerFooterViewDeleteBlock;

@end

NS_ASSUME_NONNULL_END
