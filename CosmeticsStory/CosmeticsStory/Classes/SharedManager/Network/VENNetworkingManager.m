//
//  VENNetworkingManager.m
//
//  Created by YVEN.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENNetworkingManager.h"
#import "VENNetworkResponseCodeManager.h"

static id instance;
static NSString *const url = @"http://meizhuanggushi.ahaiba.com/index.php/";
@implementation VENNetworkingManager

+ (AFHTTPSessionManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:url]];
    });
    return instance;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        // 默认请求数据的类型为 二进制 AFHTTPRequestSerializer, 若使用 JSON 改为 AFJSONRequestSerializer
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        // 请求超时时长
        self.requestSerializer.timeoutInterval = 30;
        // 忽略本地缓存 直接从后台请求数据
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        // HEADER
        //        [self.requestSerializer setValue: forHTTPHeaderField:];
        
        // 默认返回数据的类型为 JSON AFJSONResponseSerializer, 若使用 二进制 改为 AFHTTPResponseSerializer
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        // 接收的内容类型 XML text/xml, 纯文本 text/plain
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    }
    return self;
}

- (void)requestWithType:(HttpRequestType)type urlString:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock failureBlock:(HTTPRequestFailedBlock)failureBlock {
    
    NSLog(@"请求接口：%@%@", url, urlString);
    
    if (parameters == nil) parameters = @{};
    
    NSLog(@"请求参数：%@", parameters);
    
    // HEADER
    //        [self.requestSerializer setValue: forHTTPHeaderField:];
    
    switch (type) {
        case HttpRequestTypePOST: {
            [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"%@", responseObject);
                
                if ([responseObject[@"status"] integerValue] == 200) {
                    [MBProgressHUD showText:responseObject[@"message"]];
                } else {
                    [[VENNetworkResponseCodeManager sharedManager] initWithResponse:responseObject];
                    return;
                }
                
                if (successBlock) successBlock(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"%@", error);
                if (failureBlock) failureBlock(error);
            }];
            
            break;
        }
            
        case HttpRequestTypeGET: {
            [self GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"%@", responseObject);
                
                if ([responseObject[@"status"] integerValue] == 200) {
                    [MBProgressHUD showText:responseObject[@"message"]];
                } else {
                    [[VENNetworkResponseCodeManager sharedManager] initWithResponse:responseObject];
                    return;
                }
                
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

- (void)uploadImageWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters images:(NSArray *)images keyName:(NSString *)keyName successBlock:(HTTPRequestSuccessBlock)successBlock failureBlock:(HTTPRequestFailedBlock)failureBlock {
    
    NSLog(@"请求接口：%@%@", url, urlString);
    
    if (parameters == nil) parameters = @{};
    
    NSLog(@"请求参数：%@", parameters);
    
    [self POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (UIImage *image in images) {
            NSData *imageData = UIImageJPEGRepresentation([self compressImage:image toByte:102400], 1);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", [formatter stringFromDate:[NSDate date]]];
            
            [formData appendPartWithFileData:imageData name:keyName fileName:fileName mimeType:@"image/jpg"];
            
            NSLog(@"photos：%@-%@", keyName, image);
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showText:responseObject[@"message"]];
        } else {
            [[VENNetworkResponseCodeManager sharedManager] initWithResponse:responseObject];
            return;
        }
        
        if (successBlock) successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
        if (failureBlock) failureBlock(error);
    }];
}

#pragma mark - 图片压缩 (100kb = 102400byte)
- (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}

@end
