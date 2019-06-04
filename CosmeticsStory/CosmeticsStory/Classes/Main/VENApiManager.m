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

- (void)registerWithTel:(NSString *)tel code:(NSString *)code password:(NSString *)password passwords:(NSString *)passwords {
    
    NSDictionary *parameters = @{@"tel" : tel,
                                 @"code" : code,
                                 @"password" : password,
                                 @"passwords" : passwords};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"login/register" parameters:parameters successBlock:^(id  _Nonnull responseObject) {
        
        
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (void)loginWithTel:(NSString *)tel password:(NSString *)password {
    NSDictionary *parameters = @{@"tel" : tel,
                                 @"password" : password};
 
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"login/login" parameters:parameters successBlock:^(id  _Nonnull responseObject) {
        
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (void)userInfoWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"member/userInfo" parameters:nil successBlock:^(id  _Nonnull responseObject) {
        
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
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

@end
