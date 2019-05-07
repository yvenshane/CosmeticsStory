//
//  MBProgressHUD+VEN.m
//
//
//  Created by YVEN.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "MBProgressHUD+VEN.h"

@implementation MBProgressHUD (VEN)

+ (void)showText:(NSString *)text {
    UIView *view = [[UIApplication sharedApplication] keyWindow];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0f];
}

+ (void)showLoading {
    UIView *view = [[UIApplication sharedApplication] keyWindow];
    
    [self hideHUDForView:view animated:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0f];
}

+ (void)hideLoading {
    UIView *view = [[UIApplication sharedApplication] keyWindow];
    
    [self hideHUDForView:view animated:YES];
}

@end
