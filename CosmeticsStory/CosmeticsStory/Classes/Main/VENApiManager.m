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
#import "VENClassifyPageModel.h"
#import "VENHomePageFindDetailModel.h"
#import "VENHomePageSearchResultsModel.h"
#import "VENHomePageSearchCompositionModel.h"
#import "VENHomePageSearchCompositionDetailsPageModel.h"
#import "VENHomePageSearchCompositionDetailsPageCommentModel.h"
#import "VENProductDetailModel.h"
#import "VENMessageModel.h"
#import "VENCosmeticBagModel.h"
#import "VENFootprintCommentModel.h"

@implementation VENApiManager

+ (instancetype)sharedManager {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - login and register
- (void)registerWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"login/register" parameters:parameters successBlock:^(id responseObject) {
        
        successBlock(responseObject);
    }];
}

- (void)getVerificationCodeWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [MBProgressHUD addLoading];
    [self postWithUrlString:@"login/sendMsg" parameters:parameters successBlock:^(id responseObject) {
        
        successBlock(responseObject);
    }];
}

- (void)agreementWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"login/Agreement" parameters:parameters successBlock:^(id responseObject) {
        NSString *content = responseObject[@"content"];
        successBlock(content);
    }];
}

- (void)loginWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"login/login" parameters:parameters successBlock:^(id responseObject) {
        if ([responseObject[@"status"] integerValue] == 400) {
            VENDataViewController *vc = [[VENDataViewController alloc] init];
            vc.pushType = @"login";
            VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
            [[self getCurrentTopVC] presentViewController:nav animated:YES completion:nil];
            return;
        }
        
        successBlock(responseObject);
    }];
}

- (void)resetPasswordWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"login/data_getinfoPassword" parameters:parameters successBlock:^(id responseObject) {
        
        successBlock(responseObject);
    }];
}

#pragma mark - home page
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
        NSArray *contentArr = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:content];
        
        successBlock(contentArr);
    }];
}

- (void)findPageDetailWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"base/goodsNewsInfo" parameters:parameters successBlock:^(id responseObject) {

        NSDictionary *content = responseObject[@"content"];
        
        VENHomePageFindDetailModel *contentModel = [VENHomePageFindDetailModel yy_modelWithJSON:content];
        VENHomePageFindDetailModel *goodsInfoModel = [VENHomePageFindDetailModel yy_modelWithJSON:content[@"goodsInfo"]];
        
        NSDictionary *dict = @{@"content" : contentModel,
                               @"goodsInfo" : goodsInfoModel};
        successBlock(dict);
    }];
}

#pragma mark - collection
- (void)goodsNewsCollectionWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    
    [self postWithUrlString:@"member/goodsNewsCollection" parameters:parameters successBlock:^(id responseObject) {
        
       successBlock(responseObject);
    }];
}

#pragma mark - search
- (void)searchPagePopularTagsWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"base/labelSearch" parameters:nil successBlock:^(id responseObject) {
        
        NSArray *contentArr = responseObject[@"content"];
        
        successBlock(@{@"content" : contentArr});
    }];
}

- (void)searchPageProductListWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"base/goodsList" parameters:parameters successBlock:^(id responseObject) {
        
        NSArray *contentArr = [NSArray yy_modelArrayWithClass:[VENHomePageSearchResultsModel class] json:responseObject[@"content"]];
        
        successBlock(@{@"content" : contentArr});
    }];
}

- (void)searchPageProductDetailWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"base/goodsInfo" parameters:parameters successBlock:^(id responseObject) {
        
        VENProductDetailModel *model = [VENProductDetailModel yy_modelWithJSON:responseObject[@"content"]];
        
        successBlock(@{@"content" : model});
    }];
}

- (void)searchPageProductDetailCommentListWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"base/goodsCommentList" parameters:parameters successBlock:^(id responseObject) {
        
        NSArray *contentArr = [NSArray yy_modelArrayWithClass:[VENHomePageSearchCompositionDetailsPageCommentModel class] json:responseObject[@"content"]];
        
        successBlock(@{@"content" : contentArr});
    }];
}

- (void)searchPageProductDetailCommentDetailWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"base/goodsCommentInfo" parameters:parameters successBlock:^(id responseObject) {
        
        VENHomePageSearchCompositionDetailsPageCommentModel *model = [VENHomePageSearchCompositionDetailsPageCommentModel yy_modelWithJSON:responseObject[@"content"]];
        
        NSArray *replyArr = [NSArray yy_modelArrayWithClass:[VENHomePageSearchCompositionDetailsPageCommentModel class] json:model.list];
        
        successBlock(@{@"content" : model,
                       @"replyArr" : replyArr});
    }];
}

- (void)releaseProductCommentWithParameters:(NSDictionary *)parameters images:(NSArray *)images keyName:(NSString *)keyName successBlock:(HTTPRequestSuccessBlock)successBlock {
    [[VENNetworkingManager shareManager] uploadImageWithUrlString:@"member/comment_goods" parameters:parameters images:images keyName:keyName successBlock:^(id responseObject) {
        
        successBlock(responseObject);
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)searchPageProductDetailJiuCuoPageErrorTypeWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock {
    
    [self postWithUrlString:@"member/errorType" parameters:nil successBlock:^(id responseObject) {
        
        successBlock(responseObject[@"content"]);
    }];
}

- (void)searchPageProductDetailJiuCuoPageCommitWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"member/errorCorrection" parameters:parameters successBlock:^(id responseObject) {
        
        successBlock(responseObject);
    }];
}



- (void)searchPageProductListLabelWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"base/label" parameters:nil successBlock:^(id responseObject) {
        
        successBlock(responseObject);
    }];
}

- (void)searchPageCompositionListWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"base/ingredientsList" parameters:parameters successBlock:^(id responseObject) {
        
        NSArray *contentArr = [NSArray yy_modelArrayWithClass:[VENHomePageSearchCompositionModel class] json:responseObject[@"content"]];
        
        successBlock(@{@"content" : contentArr});
    }];
}

- (void)searchPageCompositionDetailWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"base/ingredientsInfo" parameters:parameters successBlock:^(id responseObject) {
        
        VENHomePageSearchCompositionDetailsPageModel *model = [VENHomePageSearchCompositionDetailsPageModel yy_modelWithJSON:responseObject[@"content"]];
        
        successBlock(@{@"content" : model});
    }];
}

- (void)searchPageCompositionDetailCommentListWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"base/ingredientsCommentList" parameters:parameters successBlock:^(id responseObject) {
        
        NSArray *contentArr = [NSArray yy_modelArrayWithClass:[VENHomePageSearchCompositionDetailsPageCommentModel class] json:responseObject[@"content"]];
        
        successBlock(@{@"content" : contentArr});
    }];
}

- (void)searchPageCompositionDetailCommentDetailWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"base/ingredientsCommentInfo" parameters:parameters successBlock:^(id responseObject) {
        
        VENHomePageSearchCompositionDetailsPageCommentModel *model = [VENHomePageSearchCompositionDetailsPageCommentModel yy_modelWithJSON:responseObject[@"content"]];
        
        NSArray *replyArr = [NSArray yy_modelArrayWithClass:[VENHomePageSearchCompositionDetailsPageCommentModel class] json:model.list];
        
        successBlock(@{@"content" : model,
                       @"replyArr" : replyArr});
    }];
}

- (void)releaseCompositionCommentWithParameters:(NSDictionary *)parameters images:(NSArray *)images keyName:(NSString *)keyName successBlock:(HTTPRequestSuccessBlock)successBlock {
    [[VENNetworkingManager shareManager] uploadImageWithUrlString:@"member/comment_ingredients" parameters:parameters images:images keyName:keyName successBlock:^(id responseObject) {
        
        successBlock(responseObject);
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)praiseCommentWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"member/commentPraise" parameters:parameters successBlock:^(id responseObject) {
        
        successBlock(responseObject);
    }];
}

#pragma mark - classify page
- (void)classifyPageWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"base/goodsCat" parameters:nil successBlock:^(id responseObject) {
        
        NSDictionary *content = responseObject[@"content"];
        
        NSArray *catArr = [NSArray yy_modelArrayWithClass:[VENClassifyPageModel class] json:content[@"cat"]];
       
        NSDictionary *dict = @{@"cat" : catArr,
                               @"image" : content[@"image"]};
        successBlock(dict);
    }];
}

- (void)classifyPageWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"base/goodsCatLowerLevel" parameters:parameters successBlock:^(id responseObject) {
        NSArray *contentArr = [NSArray yy_modelArrayWithClass:[VENClassifyPageModel class] json:responseObject[@"content"]];
        
        successBlock(@{@"content" : contentArr});
    }];
}

#pragma mark - mine page
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

- (void)modifyUserInfoWithParameters:(NSDictionary *)parameters images:(NSArray *)images keyName:(NSString *)keyName successBlock:(HTTPRequestSuccessBlock)successBlock {
    [[VENNetworkingManager shareManager] uploadImageWithUrlString:@"member/modifyUserInfo" parameters:parameters images:images keyName:keyName successBlock:^(id responseObject) {
        
        successBlock(responseObject);
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)changePhoneNumberWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"member/editTel" parameters:parameters successBlock:^(id responseObject) {
        
        successBlock(responseObject);
    }];
}

- (void)modifyPasswordWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"member/editPassword" parameters:parameters successBlock:^(id responseObject) {
        
        successBlock(responseObject);
    }];
}

- (void)myFootprintListWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"member/myCollectionNews" parameters:parameters successBlock:^(id responseObject) {
        
        NSDictionary *content = responseObject[@"content"];
        NSArray *contentArr = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:content];
        
        successBlock(contentArr);
    }];
}

- (void)myFootprintCommentProductPageWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"member/myCommentGoods" parameters:parameters successBlock:^(id responseObject) {
        
        NSDictionary *content = responseObject[@"content"];
        NSArray *contentArr = [NSArray yy_modelArrayWithClass:[VENFootprintCommentModel class] json:content];
        
        successBlock(@{@"content" : contentArr});
    }];
}

- (void)myFootprintCommentCompositionPageWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"member/myCommentIngredients" parameters:parameters successBlock:^(id responseObject) {
        
        NSDictionary *content = responseObject[@"content"];
        NSArray *contentArr = [NSArray yy_modelArrayWithClass:[VENFootprintCommentModel class] json:content];
        
        successBlock(@{@"content" : contentArr});
    }];
}

- (void)myMessageListPageWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"member/myNews" parameters:nil successBlock:^(id responseObject) {
        
        NSArray *arr = [NSArray yy_modelArrayWithClass:[VENMessageModel class] json:responseObject[@"content"]];
        
        successBlock(@{@"content" : arr});
    }];
}

- (void)myMessageDetailPageWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"member/myNewsInfo" parameters:parameters successBlock:^(id responseObject) {
        successBlock(responseObject);
    }];
}

- (void)detailPageCosmeticBagListWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"member/myCollectionCat" parameters:nil successBlock:^(id responseObject) {
        
        NSArray *arr = [NSArray yy_modelArrayWithClass:[VENCosmeticBagModel class] json:responseObject[@"content"]];
        successBlock(@{@"content" : arr});
    }];
}

- (void)detailPageCosmeticBagCollectionWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"member/collection" parameters:parameters successBlock:^(id responseObject) {
        
        successBlock(responseObject);
    }];
}

- (void)detailPageCosmeticBagAdditionWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"member/addCollectionCat" parameters:parameters successBlock:^(id responseObject) {
        
        successBlock(responseObject);
    }];
}

- (void)myCosmeticBagDetailPageWithParameters:(NSDictionary *)parameters SuccessBlock:(HTTPRequestSuccessBlock)successBlock {
    [self postWithUrlString:@"member/goodsCollectionList" parameters:parameters successBlock:^(id responseObject) {
        
        NSString *descriptionn = responseObject[@"content"][@"catInfo"][@"descriptionn"];
        NSArray *goodsListArr = [NSArray yy_modelArrayWithClass:[VENHomePageSearchResultsModel class] json:responseObject[@"content"][@"goodsList"]];
        NSArray *ingredientsListArr = [NSArray yy_modelArrayWithClass:[VENHomePageSearchCompositionModel class] json:responseObject[@"content"][@"ingredientsList"]];
        
        NSDictionary *content = @{@"descriptionn" : descriptionn,
                                  @"goodsList" : goodsListArr,
                                  @"ingredientsList" : ingredientsListArr};
        
        successBlock(@{@"content" : content});
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
