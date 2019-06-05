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

- (void)registerWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
- (void)agreementWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
- (void)loginWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
- (void)resetPasswordWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;

- (void)userInfoWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock;
- (void)modifyUserInfoWithParameters:(NSDictionary *)parameters images:(NSArray *)images keyName:(NSString *)keyName;

@end

NS_ASSUME_NONNULL_END
