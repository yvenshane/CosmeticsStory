//
//  VENTabBarController.m
//  
//  Created by YVEN.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENTabBarController.h"
#import "VENNavigationController.h"
#import "VENLoginPageViewController.h"

@interface VENTabBarController () <UITabBarControllerDelegate>

@end

@implementation VENTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIViewController *vc1 = [self loadChildViewControllerWithClassName:@"VENHomePageViewController" andTitle:@"首页" andImageName:@"icon_tab01"];
    UIViewController *vc2 = [self loadChildViewControllerWithClassName:@"VENClassifyViewController" andTitle:@"分类" andImageName:@"icon_tab02"];
    UIViewController *vc3 = [self loadChildViewControllerWithClassName:@"VENCosmeticBagViewController" andTitle:@"化妆包" andImageName:@"icon_tab03"];
    UIViewController *vc4 = [self loadChildViewControllerWithClassName:@"VENMineViewController" andTitle:@"我的" andImageName:@"icon_tab04"];
    
    self.viewControllers = @[vc1, vc2, vc3, vc4];
    
    self.delegate = self;
    self.tabBar.tintColor = COLOR_THEME;
    self.tabBar.translucent = NO;
}

- (UIViewController *)loadChildViewControllerWithClassName:(NSString *)className andTitle:(NSString *)title andImageName:(NSString *)imageName {
    
    // 把类名的字符串转成类的类型
    Class class = NSClassFromString(className);
    
    // 通过转换出来的类的类型来创建控制器
    UIViewController *vc = [class new];
    
    // 设置TabBar的文字
    vc.tabBarItem.title = title;
    
    NSString *normalImageName = [imageName stringByAppendingString:@""];
    // 设置默认状态的图片
    vc.tabBarItem.image = [[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 拼接选中状态的图片
    NSString *selectedImageName = [imageName stringByAppendingString:@"_active"];
    // 设置选中图片
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 创建导航控制器
    VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
    
    return nav;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (![[VENUserStatusManager sharedManager] isLogin]) {
        if ([viewController.tabBarItem.title isEqualToString:@"化妆包"] || [viewController.tabBarItem.title isEqualToString:@"我的"]) {
            VENLoginPageViewController *vc = [[VENLoginPageViewController alloc] init];
            vc.pushType = @"nologin";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
            return NO;
        }
    } else {
        if ([viewController.tabBarItem.title isEqualToString:@"化妆包"]) {
            tabBarController.selectedIndex = 3;
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
