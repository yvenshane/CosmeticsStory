//
//  VENRegisterPageViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/7.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENRegisterPageViewController.h"
#import "VENBaseWebViewController.h"

@interface VENRegisterPageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *newwPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@end

@implementation VENRegisterPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 去除导航栏半透明效果 使背景色为白色
    self.navigationController.navigationBar.translucent = NO;
    // 去除导航栏底部横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    self.commitButton.layer.cornerRadius = 24.0f;
    self.commitButton.layer.masksToBounds = YES;
    
    self.getVerificationCodeButton.layer.cornerRadius = 3.0f;
    self.getVerificationCodeButton.layer.masksToBounds = YES;
    self.getVerificationCodeButton.layer.borderWidth = 1.0f;
    self.getVerificationCodeButton.layer.borderColor = COLOR_THEME.CGColor;
    
    [self setupWidget];
    [self setupNavigationItemLeftBarButtonItem];
}

#pragma mark - 提交
- (IBAction)submitButtonClick:(id)sender {
    if (self.selectedButton.selected == NO) {
        [MBProgressHUD showText:@"请阅读并同意“用户协议“和“隐私政策“"];
        return;
    }
    
    NSDictionary *parameters = @{@"tel" : self.phoneNumberTextField.text,
                                 @"code" : self.verificationCodeTextField.text,
                                 @"password" : self.newwPasswordTextField.text,
                                 @"passwords" : self.confirmPasswordTextField.text};
    [[VENApiManager sharedManager] registerWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
        
    }];
}

- (IBAction)selectedButtonClick:(UIButton *)button {
    button.selected = !button.selected;
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

- (void)setupWidget {
    NSString *str = @"我已阅读并同意“用户协议”和“隐私政策”";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    attributedString.yy_color = UIColorFromRGB(0x5E5E5E);
    [attributedString yy_setTextHighlightRange:[str rangeOfString:@"“用户协议”"] color:COLOR_THEME backgroundColor:UIColorMake(246, 246, 246) tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [[VENApiManager sharedManager] agreementWithParameters:@{@"type" : @"1"} successBlock:^(id  _Nonnull responseObject) {
            VENBaseWebViewController *vc = [[VENBaseWebViewController alloc] init];
            vc.navigationItemTitle = @"用户协议";
            vc.HTMLString = responseObject;
            [self presentViewController:vc animated:YES completion:nil];
        }];
    }];
    [attributedString yy_setTextHighlightRange:[str rangeOfString:@"“隐私政策”"] color:COLOR_THEME backgroundColor:UIColorMake(246, 246, 246) tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
        [[VENApiManager sharedManager] agreementWithParameters:@{@"type" : @"2"} successBlock:^(id  _Nonnull responseObject) {
            VENBaseWebViewController *vc = [[VENBaseWebViewController alloc] init];
            vc.navigationItemTitle = @"隐私政策";
            vc.HTMLString = responseObject;
            [self presentViewController:vc animated:YES completion:nil];
        }];
    }];
    
    YYLabel *contentLabel = [[YYLabel alloc] initWithFrame:CGRectMake(38 + 16 + 8, 495.5 - 44, kMainScreenWidth - 38 - 16 - 8 - 37, 16)];
    contentLabel.attributedText = attributedString;
    [self.view addSubview:contentLabel];
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
