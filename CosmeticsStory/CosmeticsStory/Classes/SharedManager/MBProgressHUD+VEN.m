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
    
    [self hideHUDForView:view animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16.0f];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:3.0f];
    hud.userInteractionEnabled = NO;
}

+ (void)addLoading {
    UIView *view = [[UIApplication sharedApplication] keyWindow];
    [self removeLoading];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud show:YES];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:hud action:@selector(tapEvent:)];
//    tap.numberOfTapsRequired = 1;
//    [hud addGestureRecognizer:tap];
}

- (void)tapEvent:(UITapGestureRecognizer *)tap {
    MBProgressHUD *hud = (MBProgressHUD *)tap.view;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES];
}

+ (void)removeLoading {
    UIView *view = [[UIApplication sharedApplication] keyWindow];
    
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[MBProgressHUD class]]) {
            MBProgressHUD *hud = (MBProgressHUD *)subView;
            if (hud.mode == MBProgressHUDModeText) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self hideHUDForView:view animated:YES];
                });
            } else {
                [self hideHUDForView:view animated:YES];
            }
        }
    }
}

@end
