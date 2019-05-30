//
//  VENNetworkingManager.h
//
//  Created by YVEN.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    HttpRequestTypeGET,
    HttpRequestTypePOST,
} HttpRequestType;

typedef void (^HTTPRequestSuccessBlock)(id responseObject);
typedef void (^HTTPRequestFailedBlock)(NSError *error);

@interface VENNetworkingManager : NSObject
+ (AFHTTPSessionManager *)shareManager;
+ (void)requestWithType:(HttpRequestType)type urlString:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock failureBlock:(HTTPRequestFailedBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
