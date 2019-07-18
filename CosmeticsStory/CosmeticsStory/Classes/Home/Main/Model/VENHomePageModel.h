//
//  VENHomePageModel.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/5.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENHomePageModel : NSObject
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *lang;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *cat_id;
@property (nonatomic, copy) NSString *cat_name;
@property (nonatomic, copy) NSString *cat_subname;
@property (nonatomic, copy) NSString *pid;
//@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *kit_id;
//@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *cat_image;
@property (nonatomic, copy) NSString *cat_image_mobile;
@property (nonatomic, copy) NSString *rec;
@property (nonatomic, copy) NSString *is_recommend;

@property (nonatomic, copy) NSString *fraction;
//@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_thumb;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *capacity;

//@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *collectionCount;
@property (nonatomic, copy) NSDictionary *imageSize;

@property (nonatomic, copy) NSString *refraction;

@end

NS_ASSUME_NONNULL_END
