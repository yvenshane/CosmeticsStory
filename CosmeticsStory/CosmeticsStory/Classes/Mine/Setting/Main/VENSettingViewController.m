//
//  VENSettingViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/13.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENSettingViewController.h"
#import "VENDataTableViewCell.h"
#import "VENChangePhoneNumberViewController.h"
#import "VENModifyPasswordViewController.h"

@interface VENSettingViewController ()

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"设置";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VENDataTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.descriptionTextField.hidden = YES;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"更换手机";
        } else {
            cell.titleLabel.text = @"修改密码";
        }
    } else {
        cell.titleLabel.text = @"联系我们";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            VENChangePhoneNumberViewController *vc = [[VENChangePhoneNumberViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            VENModifyPasswordViewController *vc = [[VENModifyPasswordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"base/contacUs" params:@{} showLoading:NO successBlock:^(id response) {
            
            NSString *tel = [NSString stringWithFormat:@"telprompt://%@", response[@"content"]];
            
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
            }
            
        } failureBlock:^(NSError *error) {
            
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc] init];
    } else {
        UIView *footerView = [[UIView alloc] init];
        UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 270, kMainScreenWidth - 30, 48)];
        logoutButton.backgroundColor = COLOR_THEME;
        [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        logoutButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        ViewRadius(logoutButton, 24.0f);
        [logoutButton addTarget:self action:@selector(logoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:logoutButton];
        
        return footerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 5 : 270 + 48;
}

- (void)logoutButtonClick {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LOGIN"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AutoLogin"];
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Login_Out" object:nil];
    
    NSLog(@"%d", [[VENUserStatusManager sharedManager] isLogin]);
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
