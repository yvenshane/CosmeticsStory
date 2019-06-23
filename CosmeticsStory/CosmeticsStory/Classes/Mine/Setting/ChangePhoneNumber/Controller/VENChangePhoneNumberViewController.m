//
//  VENChangePhoneNumberViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/13.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENChangePhoneNumberViewController.h"
#import "VENChangePhoneNumberTableViewCell.h"
#import "VENVerificationCodeButton.h"

@interface VENChangePhoneNumberViewController ()

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENChangePhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"更换手机";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VENChangePhoneNumberTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
    
    [self setupSaveButton];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENChangePhoneNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"手机号码";
        cell.contentTextField.placeholder = @"请输入手机号码";
        cell.contentTextFieldRightLayoutConstraint.constant = 15.0f;
    } else {
        cell.titleLabel.text = @"验证码    ";
        cell.contentTextField.placeholder = @"请输入验证码";
        cell.contentTextFieldRightLayoutConstraint.constant = 120.0f;

        VENVerificationCodeButton *verificationCodeButton = [[VENVerificationCodeButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 90 - 15, 48 / 2 - 32 / 2, 90, 32)];
        [verificationCodeButton addTarget:self action:@selector(getVerificationCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:verificationCodeButton];
    }
    
    return cell;
}

- (void)getVerificationCodeButtonClick:(VENVerificationCodeButton *)button {
     VENChangePhoneNumberTableViewCell *phoneCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [[VENApiManager sharedManager] getVerificationCodeWithParameters:@{@"tel" : phoneCell.contentTextField.text} successBlock:^(id  _Nonnull responseObject) {
        [button countingDownWithCount:60];
    }];
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
    
    VENChangePhoneNumberTableViewCell *phoneCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    VENChangePhoneNumberTableViewCell *codeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSDictionary *parameters = @{@"tel" : phoneCell.contentTextField.text,
                                 @"code" : codeCell.contentTextField.text};
    
    [[VENApiManager sharedManager] changePhoneNumberWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
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
