//
//  VENProductDetailModel.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/20.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENProductDetailModel : NSObject
@property (nonatomic, copy) NSString *active_ingredients;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *brand_id;
@property (nonatomic, copy) NSString *capacity;
@property (nonatomic, copy) NSString *cas;
@property (nonatomic, copy) NSString *cat_id;
@property (nonatomic, copy) NSString *enterprise_ch;
@property (nonatomic, copy) NSString *enterprise_en;
@property (nonatomic, copy) NSString *fraction;

@property (nonatomic, copy) NSDictionary *goods_brand;
@property (nonatomic, copy) NSString *ascription;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *found_time;
@property (nonatomic, copy) NSString *founder;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *name_ch;
@property (nonatomic, copy) NSString *name_en;
@property (nonatomic, copy) NSString *origin;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *website;

@property (nonatomic, copy) NSString *goods_content;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_image;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_name_alias;
@property (nonatomic, copy) NSString *goods_name_ch;
@property (nonatomic, copy) NSString *goods_name_en;
@property (nonatomic, copy) NSString *goods_thumb;

@property (nonatomic, copy) NSArray *ingredientContent;
@property (nonatomic, copy) NSArray *label_purpose;

@property (nonatomic, copy) NSString *limit;
@property (nonatomic, copy) NSString *place_of_production;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *price_id;
@property (nonatomic, copy) NSString *record_number;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *url_image;
@property (nonatomic, copy) NSString *userCollection;

@property (nonatomic, copy) NSString *descriptionn;

@property (nonatomic, copy) NSDictionary *share;
@property (nonatomic, copy) NSString *commentNumber;

@end

NS_ASSUME_NONNULL_END
