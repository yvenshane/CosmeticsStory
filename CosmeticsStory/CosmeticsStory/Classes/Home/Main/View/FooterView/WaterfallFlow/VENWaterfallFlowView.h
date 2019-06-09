//
//  VENWaterfallFlowView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/17.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENWaterfallFlowView : UIView
@property (nonatomic, copy) NSArray *goodsNewsListArr;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
