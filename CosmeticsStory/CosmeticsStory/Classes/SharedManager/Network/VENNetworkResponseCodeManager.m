//
//  VENNetworkResponseCodeManager.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/31.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENNetworkResponseCodeManager.h"
#import "VENLoginPageViewController.h"
#import "VENDataViewController.h"

static id instance;
static dispatch_once_t onceToken;
@implementation VENNetworkResponseCodeManager
+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)initWithResponse:(id)response {
    NSInteger code = [response[@"status"] integerValue];
    NSString *message = response[@"message"];
    
    if (code == 203) {
        VENLoginPageViewController *vc = [[VENLoginPageViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [[self getCurrentTopVC] presentViewController:nav animated:YES completion:nil];
    } if (code == 400) {
        VENDataViewController *vc = [[VENDataViewController alloc] init];
        vc.isPresent = YES;
        VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
        [[self getCurrentTopVC] presentViewController:nav animated:YES completion:nil];
    }
    
    [MBProgressHUD showText:message];
}

//获取当前屏幕显示的rootViewController
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
