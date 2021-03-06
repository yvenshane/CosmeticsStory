//
//  VENLoginPageViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/7.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENLoginPageViewController.h"
#import "VENResetPasswordViewController.h"
#import "VENRegisterPageViewController.h"
#import "VENBindingPhoneViewController.h"
#import <UMShare/UMShare.h>
#import "VENDataViewController.h"

@interface VENLoginPageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation VENLoginPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 去除导航栏半透明效果 使背景色为白色
    self.navigationController.navigationBar.translucent = NO;
    // 去除导航栏底部横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    self.loginButton.layer.cornerRadius = 24.0f;
    self.loginButton.layer.masksToBounds = YES;
    
    [self setupNavigationItemLeftBarButtonItem];
}

#pragma mark - 登录
- (IBAction)loginButtonClick:(id)sender {
    NSDictionary *parameters = @{@"tel" : self.phoneNumberTextField.text,
                                 @"password" : self.passwordTextField.text};
    [[VENApiManager sharedManager] loginWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
        
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"content"] forKey:@"LOGIN"];
        
        NSDictionary *dict = @{@"type" : @"login",
                               @"tel" : self.phoneNumberTextField.text,
                               @"password" : self.passwordTextField.text};
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"AutoLogin"];
       
        if ([self.pushType isEqualToString:@"initialPage"]) {
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }

        NSLog(@"%d", [[VENUserStatusManager sharedManager] isLogin]);
    }];
}

#pragma mark - 忘记密码
- (IBAction)forgetPasswordButtonClick:(id)sender {
    VENResetPasswordViewController *vc = [[VENResetPasswordViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 注册
- (IBAction)registerButtonClick:(id)sender {
    VENRegisterPageViewController *vc = [[VENRegisterPageViewController alloc] init];
    vc.pushType = @"register";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 微信登录
- (IBAction)wechatButtonClick:(id)sender {
    [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
}

#pragma mark - QQ 登录
- (IBAction)qqButtonClick:(id)sender {
    [self getUserInfoForPlatform:UMSocialPlatformType_QQ];
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        
        
        UMSocialUserInfoResponse *resp = result;
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        NSLog(@" unionId: %@", resp.unionId);
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        
        NSString *platform = @"";
        if (platformType == UMSocialPlatformType_WechatSession) {
            platform = @"Wechat";
        } else if (platformType == UMSocialPlatformType_QQ) {
            platform = @"QQ";
        }
        
        [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"login/submitOtherLogin" parameters:@{@"platform" : platform, @"unique" : resp.uid} successBlock:^(id responseObject) {
            
            if ([responseObject[@"status"] integerValue] == 205) {
                VENBindingPhoneViewController *vc = [[VENBindingPhoneViewController alloc] init];
                vc.platform = platform;
                vc.unique = resp.uid;
                vc.pushType = self.pushType;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            } else if ([responseObject[@"status"] integerValue] == 200) {
                
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"content"] forKey:@"LOGIN"];
                
                NSDictionary *dict = @{@"type" : platform,
                                       @"unique" : resp.uid};
                
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"AutoLogin"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh_Mine_Page" object:nil];
                
                if ([self.pushType isEqualToString:@"initialPage"]) {
                    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            } else if ([responseObject[@"status"] integerValue] == 400) {
                VENDataViewController *vc = [[VENDataViewController alloc] init];
                vc.pushType = @"login";
                VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }

        } failureBlock:^(NSError *error) {
            
        }];
    }];
}

- (void)setupNavigationItemLeftBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
