//
//  VENDataPageModel.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/31.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENDataPageModel : NSObject
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *constellation_id;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *occupation_id;
@property (nonatomic, copy) NSString *qq_unique;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *skin_texture_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *wx_unique;

@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
