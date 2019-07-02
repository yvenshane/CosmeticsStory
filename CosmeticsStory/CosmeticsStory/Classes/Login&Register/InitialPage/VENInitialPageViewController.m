//
//  VENInitialPageViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/7.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENInitialPageViewController.h"
#import "VENLoginPageViewController.h"
#import "VENRegisterPageViewController.h"

@interface VENInitialPageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation VENInitialPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.loginButton.layer.cornerRadius = 24.0f;
    self.loginButton.layer.masksToBounds = YES;
}

#pragma mark - 登录
- (IBAction)loginButtonClick:(id)sender {
    VENLoginPageViewController *vc = [[VENLoginPageViewController alloc] init];
    vc.pushType = @"initialPage";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 注册
- (IBAction)registerButtonClick:(id)sender {
    VENRegisterPageViewController *vc = [[VENRegisterPageViewController alloc] init];
    vc.pushType = @"initialPage";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 随便看看
- (IBAction)cancelButtonClick:(id)sender {
    NSLog(@"随便看看");
    
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
