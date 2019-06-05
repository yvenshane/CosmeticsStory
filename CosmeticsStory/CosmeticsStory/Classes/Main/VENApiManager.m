//
//  VENApi.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/31.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENApiManager.h"
#import "VENDataPageModel.h"

@implementation VENApiManager

+ (instancetype)sharedManager {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)registerWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"login/register" parameters:parameters successBlock:^(id responseObject) {
        
        successBlock(responseObject);
    }];
}

- (void)agreementWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"login/Agreement" parameters:parameters successBlock:^(id responseObject) {
        NSString *content = responseObject[@"content"];
        successBlock(content);
    }];
}

- (void)loginWithParameters:(NSDictionary *)parameters successBlock:(nonnull HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"login/login" parameters:parameters successBlock:^(id responseObject) {
        
        successBlock(responseObject);
    }];
}

- (void)userInfoWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"member/userInfo" parameters:nil successBlock:^(id responseObject) {
        NSDictionary *content = responseObject[@"content"];
        
        NSArray *label_constellationArr = [NSArray yy_modelArrayWithClass:[VENDataPageModel class] json:content[@"label_constellation"]];
        NSArray *label_occupationArr = [NSArray yy_modelArrayWithClass:[VENDataPageModel class] json:content[@"label_occupation"]];
        NSArray *label_skinArr = [NSArray yy_modelArrayWithClass:[VENDataPageModel class] json:content[@"label_skin"]];
        VENDataPageModel *userInfoModel = [VENDataPageModel yy_modelWithJSON:content[@"userInfo"]];
        
        NSArray *genderArr = @[@{@"id" : @"1", @"name" : @"男"},
                               @{@"id" : @"2", @"name" : @"女"}];
        genderArr = [NSArray yy_modelArrayWithClass:[VENDataPageModel class] json:genderArr];
        
        NSDictionary *dict = @{@"label_constellation" : label_constellationArr,
                               @"label_occupation" : label_occupationArr,
                               @"label_skin" : label_skinArr,
                               @"userInfo" : userInfoModel,
                               @"label_gender" : genderArr};
        
        successBlock(dict);
    }];
}

- (void)modifyUserInfoWithParameters:(NSDictionary *)parameters images:(NSArray *)images keyName:(NSString *)keyName {
    [[VENNetworkingManager shareManager] uploadImageWithUrlString:@"member/modifyUserInfo" parameters:parameters images:images keyName:keyName successBlock:^(id responseObject) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - POST
- (void)postWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:urlString parameters:parameters successBlock:^(id  _Nonnull responseObject) {
        
        successBlock(responseObject);
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}



@end
