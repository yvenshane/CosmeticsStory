//
//  VENAboutUsViewController.h
//
//
//  Created by YVEN.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VENAboutUsViewController : VENBaseViewController
@property (nonatomic, copy) NSString *HTMLString;
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, copy) NSString *navigationItemTitle;

@end

NS_ASSUME_NONNULL_END
