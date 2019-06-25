//
//  VENFootprintCommentModel.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/25.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENFootprintCommentModel : NSObject
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_thumb;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *ingredients_id;
@property (nonatomic, copy) NSString *ingredients_name;

@end

NS_ASSUME_NONNULL_END
