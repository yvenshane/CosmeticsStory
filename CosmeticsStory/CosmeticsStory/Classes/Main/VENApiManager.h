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

// 注册
- (void)registerWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 获取验证码
- (void)getVerificationCodeWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 用户协议 隐私政策
- (void)agreementWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 登录
- (void)loginWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 重置密码
- (void)resetPasswordWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;

// 首页
- (void)homePageWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock;
// 优惠券
- (void)couponListWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 发现页
- (void)goodsNewsListWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 发现详情页
- (void)findPageDetailWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;

// 发现详情页 收藏
- (void)goodsNewsCollectionWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;

// 搜索 热门搜索
- (void)searchPagePopularTagsWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock;
// 搜索 产品列表页
- (void)searchPageProductListWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 搜索 产品列表页 顶部标签
- (void)searchPageProductListLabelWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock;
// 搜索 产品详情页
- (void)searchPageProductDetailWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 搜索 产品详情页 评论列表
- (void)searchPageProductDetailCommentListWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 搜索 产品详情页 评论详情页
- (void)searchPageProductDetailCommentDetailWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 搜索 产品详情页 发布评论/回复
- (void)releaseProductCommentWithParameters:(NSDictionary *)parameters images:(NSArray *)images keyName:(NSString *)keyName successBlock:(HTTPRequestSuccessBlock)successBlock;
// 搜索 产品详情页 纠错
- (void)searchPageProductDetailJiuCuoPageErrorTypeWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock;
// 搜索 产品详情页 纠错提交
- (void)searchPageProductDetailJiuCuoPageCommitWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 搜索 产品详情页 全部成分/标签
- (void)searchPageProductDetailAllCompositionPageLabelWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock;
// 搜索 产品详情页 全部成分
- (void)searchPageProductDetailAllCompositionPageWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;

// 搜索 成分列表页
- (void)searchPageCompositionListWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 搜索 成分详情页
- (void)searchPageCompositionDetailWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 搜索 成分详情页 评论列表
- (void)searchPageCompositionDetailCommentListWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 搜索 成分详情页 评论详情页
- (void)searchPageCompositionDetailCommentDetailWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;

// 搜索 成分详情页 发布评论/回复
- (void)releaseCompositionCommentWithParameters:(NSDictionary *)parameters images:(NSArray *)images keyName:(NSString *)keyName successBlock:(HTTPRequestSuccessBlock)successBlock;
// 搜索 成分详情页 点赞
- (void)praiseCommentWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;

// 分类 一级列表
- (void)classifyPageWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock;
// 分类 二级列表
- (void)classifyPageWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;

// 我的 足迹 好文
- (void)myFootprintListWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 我的 足迹 评论/产品
- (void)myFootprintCommentProductPageWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 我的 足迹 评论/成分
- (void)myFootprintCommentCompositionPageWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 我的 消息 列表页
- (void)myMessageListPageWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock;
// 我的 消息 详情页
- (void)myMessageDetailPageWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 我的 资料
- (void)userInfoWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock;
// 我的 资料 保存
- (void)modifyUserInfoWithParameters:(NSDictionary *)parameters images:(NSArray *)images keyName:(NSString *)keyName successBlock:(HTTPRequestSuccessBlock)successBlock;
// 我的 设置/更换手机
- (void)changePhoneNumberWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 我的 设置/修改密码
- (void)modifyPasswordWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;

// 详情页 化妆包列表
- (void)detailPageCosmeticBagListWithSuccessBlock:(HTTPRequestSuccessBlock)successBlock;
// 详情页 化妆包 收藏
- (void)detailPageCosmeticBagCollectionWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 详情页 化妆包 新增
- (void)detailPageCosmeticBagAdditionWithParameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock;
// 我的 化妆包 详情页
- (void)myCosmeticBagDetailPageWithParameters:(NSDictionary *)parameters SuccessBlock:(HTTPRequestSuccessBlock)successBlock;

@end

NS_ASSUME_NONNULL_END
