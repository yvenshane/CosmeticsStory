//
//  VENApi.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/31.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENApiManager.h"
#import "VENDataViewController.h"
#import "VENDataPageModel.h"
#import "VENHomePageModel.h"
#import "VENHomePageCouponModel.h"

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
        if ([responseObject[@"status"] integerValue] == 400) {
            VENDataViewController *vc = [[VENDataViewController alloc] init];
            vc.isPresent = YES;
            VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
            [[self getCurrentTopVC] presentViewController:nav animated:YES completion:nil];
            return;
        }
        
        successBlock(responseObject);
    }];
}

- (void)resetPasswordWithParameters:(NSDictionary *)parameters successBlock:(nonnull HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"login/data_getinfoPassword" parameters:parameters successBlock:^(id responseObject) {
        
        successBlock(responseObject);
    }];
}



- (void)homePageWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"base/index" parameters:nil successBlock:^(id responseObject) {
        
        NSDictionary *content = responseObject[@"content"];
        
        NSArray *bannerListArr = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:content[@"bannerList"]];
        NSArray *catListArr = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:content[@"catList"]];
        NSArray *goodsNewsListArr = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:content[@"goodsNewsList"]];
        NSArray *recommendListArr = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:content[@"recommendList"]];
        
        NSDictionary *dict = @{@"bannerList" : bannerListArr,
                               @"catList" : catListArr,
                               @"goodsNewsList" : goodsNewsListArr,
                               @"recommendList" : recommendListArr};
        
        successBlock(dict);
    }];
}

- (void)couponListWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"base/couponList" parameters:parameters successBlock:^(id responseObject) {
        
        NSDictionary *content = responseObject[@"content"];
        NSArray *contentArr = [NSArray yy_modelArrayWithClass:[VENHomePageCouponModel class] json:content];
        
        successBlock(contentArr);
    }];
}

- (void)goodsNewsListWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"base/goodsNewsList" parameters:parameters successBlock:^(id responseObject) {
        
        NSDictionary *content = responseObject[@"content"];
        NSArray *contentArr = [NSArray yy_modelArrayWithClass:[VENHomePageCouponModel class] json:content];
        
        successBlock(contentArr);
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

#pragma mark - 获取当前屏幕显示的rootViewController
- (UIViewController *)getCurrentTopVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return [self getTopViewController:result];
}

- (UIViewController *)getTopViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self getTopViewController:[(UITabBarController *)viewController selectedViewController]];
        
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [self getTopViewController:[(UINavigationController *)viewController topViewController]];
        
    } else if (viewController.presentedViewController) {
        return [self getTopViewController:viewController.presentedViewController];
        
    } else {
        return viewController;
    }
}

@end
