//
//  VENApi.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/31.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HTTPRequestSuccessBlock)(id responseObject);
@interface VENApiManager : NSObject

+ (instancetype)sharedManager;

- (void)registerWithTel:(NSString *)tel code:(NSString *)code password:(NSString *)password passwords:(NSString *)passwords;
- (void)loginWithTel:(NSString *)tel password:(NSString *)password;

- (void)userInfoWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock;

@end

NS_ASSUME_NONNULL_END
