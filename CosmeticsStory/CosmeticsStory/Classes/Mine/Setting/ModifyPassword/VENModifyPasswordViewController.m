//
//  VENModifyPasswordViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/13.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENModifyPasswordViewController.h"
#import "VENChangePhoneNumberTableViewCell.h"

@interface VENModifyPasswordViewController ()

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"修改密码";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VENChangePhoneNumberTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
    
    [self setupSaveButton];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENChangePhoneNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.contentTextFieldRightLayoutConstraint.constant = 15.0f;
    cell.contentTextField.secureTextEntry = YES;
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"原密码    ";
        cell.contentTextField.placeholder = @"请输入原密码";
    } else if (indexPath.row == 1) {
        cell.titleLabel.text = @"新密码    ";
        cell.contentTextField.placeholder = @"请输入新密码";
    } else {
        cell.titleLabel.text = @"确认密码";
        cell.contentTextField.placeholder = @"请再次输入新密码";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark - SaveButton
- (void)setupSaveButton {
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:COLOR_THEME forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)saveButtonClick {
    VENChangePhoneNumberTableViewCell *passwordCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    VENChangePhoneNumberTableViewCell *passwordCell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    VENChangePhoneNumberTableViewCell *passwordCell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    NSDictionary *parameters = @{@"password1" : passwordCell.contentTextField.text,
                                 @"password2" : passwordCell2.contentTextField.text,
                                 @"password3" : passwordCell3.contentTextField.text};
    
    [[VENApiManager sharedManager] modifyPasswordWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LOGIN"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Login_Out" object:nil];
    }];
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
