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
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16.0f];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:3.0f];
}

@end
