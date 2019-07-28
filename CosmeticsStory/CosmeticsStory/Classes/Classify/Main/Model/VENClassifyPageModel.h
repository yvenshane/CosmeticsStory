//
//  VENClassifyPageModel.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENClassifyPageModel : NSObject
@property (nonatomic, copy) NSString *cat_id;
@property (nonatomic, copy) NSString *cat_image;
@property (nonatomic, copy) NSString *cat_name;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
