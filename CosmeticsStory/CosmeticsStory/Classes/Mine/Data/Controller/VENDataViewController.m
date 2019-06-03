//
//  VENDataViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENDataViewController.h"
#import "VENDataTableViewCell.h"
#import "VENDatePickerView.h"
#import "VENListPickerView.h"
#import "VENDataPageModel.h"

@interface VENDataViewController ()
@property (nonatomic, copy) NSString *tempString;
@property (nonatomic, copy) NSString *tempString2;

@property (nonatomic, copy) NSArray *label_constellationArr;
@property (nonatomic, copy) NSArray *label_occupationArr;
@property (nonatomic, copy) NSArray *label_skinArr;
@property (nonatomic, strong) VENDataPageModel *userInfoModel;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"资料";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VENDataTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
    
    [self setupSaveButton];
    
    [self loadDataSource];
}

- (void)loadDataSource {
    [[VENApiManager sharedManager] userInfoWithSuccessBlock:^(id  _Nonnull responseObject) {
        self.label_constellationArr = responseObject[@"label_constellation"];
        self.label_occupationArr = responseObject[@"label_occupation"];
        self.label_skinArr = responseObject[@"label_skin"];
        self.userInfoModel = responseObject[@"userInfo"];
        
        [self.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 4;
    } else if (section == 2) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"头像";
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfoModel.avatar] placeholderImage:[UIImage imageNamed:@"icon_touxiang2"]];
            cell.descriptionTextField.userInteractionEnabled = NO;
        } else if (indexPath.row == 1) {
            cell.titleLabel.text = @"昵称";
            cell.descriptionTextField.userInteractionEnabled = YES;
            cell.descriptionTextField.text = self.userInfoModel.name;
        } else {
            cell.titleLabel.text = @"帐号";
            cell.descriptionTextField.userInteractionEnabled = YES;
            cell.descriptionTextField.text = self.userInfoModel.id;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"出生日期";
            cell.descriptionTextField.text = self.tempString;
        } else if (indexPath.row == 1) {
            cell.titleLabel.text = @"年龄";
            cell.descriptionTextField.text = self.tempString2;
        } else if (indexPath.row == 2) {
            cell.titleLabel.text = @"星座";
            cell.descriptionTextField.text = @"";
        } else {
            cell.titleLabel.text = @"性别（不能修改）";
            cell.descriptionTextField.text = @"";
        }
        cell.descriptionTextField.userInteractionEnabled = NO;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"职业";
            cell.descriptionTextField.userInteractionEnabled = NO;
            cell.descriptionTextField.text = @"";
        } else {
            cell.titleLabel.text = @"城市";
            cell.descriptionTextField.userInteractionEnabled = YES;
            cell.descriptionTextField.text = @"";
        }
    } else {
        cell.titleLabel.text = @"肤质";
        cell.descriptionTextField.userInteractionEnabled = NO;
        cell.descriptionTextField.text = @"";
    }
    
    cell.descriptionTextField.hidden = indexPath.section == 0 && indexPath.row == 0 ? YES : NO;
    cell.iconImageView.hidden = indexPath.section == 0 && indexPath.row == 0 ? NO : YES;
    
    if (cell.descriptionTextField.userInteractionEnabled) {
        cell.descriptionTextField.placeholder = @"请填写";
        cell.arrowImageView.hidden = YES;
    } else {
        cell.descriptionTextField.placeholder = @"请选择";
        cell.arrowImageView.hidden = NO;
    }
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.descriptionTextField.userInteractionEnabled = NO;
        cell.descriptionTextField.placeholder = @"无数据";
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.arrowImageView.hidden = YES;
        cell.descriptionTextField.placeholder = @"无数据";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.view endEditing:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *appropriateAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *undeterminedAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alert addAction:appropriateAction];
                [alert addAction:undeterminedAction];
                [alert addAction:cancelAction];
                
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
    } else if (indexPath.section == 1) {
        [self.view endEditing:YES];
        
        if (indexPath.row == 0) {
            VENDatePickerView *datePickerView = [[VENDatePickerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
            datePickerView.title = @"出生日期";
            datePickerView.date = self.tempString;
            [datePickerView show];
            datePickerView.datePickerViewBlock = ^(NSString *str) {
                self.tempString = str;
                self.tempString2 = [self getAgeWithString:str];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:1], [NSIndexPath indexPathForRow:1 inSection:1], nil] withRowAnimation:UITableViewRowAnimationNone];
                
            };
            [[UIApplication sharedApplication].keyWindow addSubview:datePickerView];
        } else if (indexPath.row == 2) {
            
        } else if (indexPath.row == 3) {
            NSArray *genderArr = @[@"男", @"女"];
            VENListPickerView *listPickerView = [[VENListPickerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
            listPickerView.viewHeight = genderArr.count * 58;
            
            listPickerView.title = @"性别";
            listPickerView.dataSourceArr = genderArr;
            [listPickerView show];
            [[UIApplication sharedApplication].keyWindow addSubview:listPickerView];
        }
    } else if (indexPath.section == 2) {
        
    } else {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 && indexPath.row == 0 ? 60 : 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 3 ? 10 : 5;
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
    
    VENDataTableViewCell *iconCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    VENDataTableViewCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    VENDataTableViewCell *birthdayCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    NSDictionary *parameters = @{@"name" : nameCell.descriptionTextField.text,
                                 @"birthday" : birthdayCell.descriptionTextField.text
                                 };
    
    [[VENNetworkingManager shareManager] uploadImageWithUrlString:@"member/modifyUserInfo" parameters:parameters images:@[iconCell.iconImageView.image] keyName:@"avatar" successBlock:^(id responseObject) {
        
        
        if (self.isPresent) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
    
    

}

- (NSString *)getAgeWithString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy";
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"%ld岁", [today integerValue] - [[string substringToIndex:4] integerValue]];
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
