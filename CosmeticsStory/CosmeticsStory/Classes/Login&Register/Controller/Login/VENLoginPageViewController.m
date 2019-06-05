//
//  VENLoginPageViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/7.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENLoginPageViewController.h"
#import "VENResetPasswordViewController.h"
#import "VENBindingPhoneViewController.h"

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
    
    
    self.phoneNumberTextField.text = @"15305532222";
    self.passwordTextField.text = @"111111";
}

#pragma mark - 登录
- (IBAction)loginButtonClick:(id)sender {
    NSDictionary *parameters = @{@"tel" : self.phoneNumberTextField.text,
                                 @"password" : self.passwordTextField.text};
    [[VENApiManager sharedManager] loginWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
        
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"content"] forKey:@"LOGIN"];
       [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];

        NSLog(@"%d", [[VENUserStatusManager sharedManager] isLogin]);
    }];
}

#pragma mark - 忘记密码
- (IBAction)forgetPasswordButtonClick:(id)sender {
    VENResetPasswordViewController *vc = [[VENResetPasswordViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 微信登录
- (IBAction)wechatButtonClick:(id)sender {
    VENBindingPhoneViewController *vc = [[VENBindingPhoneViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - QQ 登录
- (IBAction)qqButtonClick:(id)sender {
    
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
