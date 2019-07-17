//
//  VENHomePageFindDetailModel.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENHomePageFindDetailModel : NSObject
@property (nonatomic, copy) NSString *collectionCount;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userCollection;

// goodsInfo
@property (nonatomic, copy) NSString *capacity;
@property (nonatomic, copy) NSString *fraction;
//@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_thumb;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *refraction;

@end

NS_ASSUME_NONNULL_END
