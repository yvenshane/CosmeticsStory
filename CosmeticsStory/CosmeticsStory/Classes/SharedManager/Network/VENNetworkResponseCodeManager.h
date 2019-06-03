//
//  VENNetworkResponseCodeManager.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/31.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENNetworkResponseCodeManager : NSObject
+ (instancetype)sharedManager;
- (void)initWithResponse:(id)response;

@end

NS_ASSUME_NONNULL_END
