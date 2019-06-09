//
//  VENHomePageTableHeaderView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/16.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^homePageTableHeaderViewBlock)(NSString *);
@interface VENHomePageTableHeaderView : UIView
@property (nonatomic, copy) NSArray *bannerListArr;
@property (nonatomic, copy) NSArray *catListArr;

@property (nonatomic, copy) homePageTableHeaderViewBlock homePageTableHeaderViewBlock;

@end

NS_ASSUME_NONNULL_END
