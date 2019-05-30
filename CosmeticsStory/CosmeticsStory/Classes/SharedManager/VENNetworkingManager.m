//
//  VENNetworkingManager.m
//
//  Created by YVEN.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENNetworkingManager.h"

static AFHTTPSessionManager *HTTPSessionManager;
static NSString *const url = @"http://meizhuanggushi.ahaiba.com/index.php/";
@implementation VENNetworkingManager
+ (AFHTTPSessionManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HTTPSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
        
        // 默认请求数据的类型为 二进制 AFHTTPRequestSerializer, 若使用 JSON 改为 AFJSONRequestSerializer
        HTTPSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        // 请求超时时长
        HTTPSessionManager.requestSerializer.timeoutInterval = 30;
        // 忽略本地缓存 直接从后台请求数据
        HTTPSessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        // HEADER
        //        [HTTPSessionManager.requestSerializer setValue: forHTTPHeaderField:];
        
        // 默认返回数据的类型为 JSON AFJSONResponseSerializer, 若使用 二进制 改为 AFHTTPResponseSerializer
        HTTPSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        // 接收的内容类型 XML text/xml, 纯文本 text/plain
        HTTPSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    });
    return HTTPSessionManager;
}

+ (void)requestWithType:(HttpRequestType)type urlString:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock failureBlock:(HTTPRequestFailedBlock)failureBlock {
    
    NSLog(@"请求接口：%@%@", url, urlString);
    
    if (parameters == nil) parameters = @{};
    
    // HEADER
    //        [HTTPSessionManager.requestSerializer setValue: forHTTPHeaderField:];
    
    switch (type) {
        case HttpRequestTypePOST: {
            [HTTPSessionManager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                
                NSLog(@"%@", responseObject);
                if (successBlock) successBlock(responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"%@", error);
                if (failureBlock) failureBlock(error);
            }];
            
            break;
        }
            
        case HttpRequestTypeGET: {
            [HTTPSessionManager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"%@", responseObject);
                if (successBlock) successBlock(responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"%@", error);
                if (failureBlock) failureBlock(error);
            }];
            
            break;
        }
            
        default:
            break;
    }
}

@end
