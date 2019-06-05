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

@interface VENDataViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *occupation;
@property (nonatomic, copy) NSString *skin;

@property (nonatomic, copy) NSString *constellationID;
@property (nonatomic, copy) NSString *genderID;
@property (nonatomic, copy) NSString *occupationID;
@property (nonatomic, copy) NSString *skinID;

@property (nonatomic, copy) NSArray *label_constellationArr;
@property (nonatomic, copy) NSArray *label_occupationArr;
@property (nonatomic, copy) NSArray *label_skinArr;
@property (nonatomic, copy) NSArray *label_genderArr;
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
        self.label_genderArr = responseObject[@"label_gender"];
        
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
            
            if (self.iconImage) {
                cell.iconImageView.image = self.iconImage;
            } else {
                [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfoModel.avatar] placeholderImage:[UIImage imageNamed:@"icon_touxiang2"]];
            }
            
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
            
            if ([VENEmptyClass isEmptyString:self.birthday]) {
                cell.descriptionTextField.text = [self.userInfoModel.birthday integerValue] == 0 ? @"" : self.userInfoModel.birthday;
            } else {
                cell.descriptionTextField.text = self.birthday;
            }
            
        } else if (indexPath.row == 1) {
            cell.titleLabel.text = @"年龄";
            
            if ([VENEmptyClass isEmptyString:self.birthday]) {
                cell.descriptionTextField.text = [self.userInfoModel.birthday integerValue] == 0 ? @"" : [self getAgeWithString:self.userInfoModel.birthday];
            } else {
                cell.descriptionTextField.text = [self getAgeWithString:self.birthday];
            }

        } else if (indexPath.row == 2) {
            cell.titleLabel.text = @"星座";
            
            if ([VENEmptyClass isEmptyString:self.constellation]) {
                
                if ([self.userInfoModel.constellation_id integerValue] == 0) {
                    cell.descriptionTextField.text = @"";
                } else {
                    for (VENDataPageModel *model in self.label_constellationArr) {
                        if ([model.id isEqualToString:self.userInfoModel.constellation_id]) {
                            cell.descriptionTextField.text = model.name;
                        }
                    }
                }
            } else {
                cell.descriptionTextField.text = self.constellation;
            }
            
        } else {
            cell.titleLabel.text = @"性别（不能修改）";
            
            if ([VENEmptyClass isEmptyString:self.gender]) {
                
                if ([self.userInfoModel.sex integerValue] == 0) {
                    cell.descriptionTextField.text = @"";
                } else {
                    for (VENDataPageModel *model in self.label_genderArr) {
                        if ([model.id isEqualToString:self.userInfoModel.sex]) {
                            cell.descriptionTextField.text = model.name;
                        }
                    }
                }
            } else {
                cell.descriptionTextField.text = self.gender;
            }
        }
        cell.descriptionTextField.userInteractionEnabled = NO;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"职业";
            cell.descriptionTextField.userInteractionEnabled = NO;
            
            if ([VENEmptyClass isEmptyString:self.occupation]) {
                
                if ([self.userInfoModel.occupation_id integerValue] == 0) {
                    cell.descriptionTextField.text = @"";
                } else {
                    
                    for (VENDataPageModel *model in self.label_occupationArr) {
                        if ([model.id isEqualToString:self.userInfoModel.occupation_id]) {
                            cell.descriptionTextField.text = model.name;
                            
                        }
                    }
                }
            } else {
                cell.descriptionTextField.text = self.occupation;
            }
        } else {
            cell.titleLabel.text = @"城市";
            cell.descriptionTextField.userInteractionEnabled = YES;
            cell.descriptionTextField.text = self.userInfoModel.address;
        }
    } else {
        cell.titleLabel.text = @"肤质";
        cell.descriptionTextField.userInteractionEnabled = NO;
        
        if ([VENEmptyClass isEmptyString:self.skin]) {
            
            if ([self.userInfoModel.skin_texture_id integerValue] == 0) {
                cell.descriptionTextField.text = @"";
            } else {
                for (VENDataPageModel *model in self.label_skinArr) {
                    if ([model.id isEqualToString:self.userInfoModel.skin_texture_id]) {
                        cell.descriptionTextField.text = model.name;
                    }
                }
            }
        } else {
            cell.descriptionTextField.text = self.skin;
        }
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
        if (indexPath.row == 0) { // 头像
            [self.view endEditing:YES];
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *appropriateAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                }];
                UIAlertAction *undeterminedAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:imagePickerController animated:YES completion:nil];
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
            datePickerView.date = self.birthday;
            
            [datePickerView show];
            datePickerView.datePickerViewBlock = ^(NSString *str) {
                self.birthday = str;
                
                [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1], [NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:datePickerView];
        } else if (indexPath.row == 2) {
            
            if (self.label_constellationArr.count > 0) {
                VENListPickerView *listPickerView = [[VENListPickerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                listPickerView.viewHeight = self.label_constellationArr.count > 5 ? 5 * 58 : self.label_constellationArr.count * 58;
                
                listPickerView.title = @"星座";
                listPickerView.dataSourceArr = self.label_constellationArr;
                
                [listPickerView show];
                listPickerView.listPickerViewBlock = ^(VENDataPageModel *model) {
                    self.constellation = model.name;
                    self.constellationID = model.id;
                    
                    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                };
                [[UIApplication sharedApplication].keyWindow addSubview:listPickerView];
            }
            
        } else if (indexPath.row == 3) {
            
            if ([self.userInfoModel.sex integerValue] == 0) {
                if (self.label_genderArr.count > 0) {
                    VENListPickerView *listPickerView = [[VENListPickerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                    listPickerView.viewHeight = self.label_genderArr.count * 58;
                    
                    listPickerView.title = @"性别";
                    listPickerView.dataSourceArr = self.label_genderArr;
                    
                    [listPickerView show];
                    listPickerView.listPickerViewBlock = ^(VENDataPageModel *model) {
                        self.gender = model.name;
                        self.genderID = model.id;
                        
                        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                    };
                    [[UIApplication sharedApplication].keyWindow addSubview:listPickerView];
                }
            }
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self.view endEditing:YES];
            
            if (self.label_occupationArr.count > 0) {
                VENListPickerView *listPickerView = [[VENListPickerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                listPickerView.viewHeight = self.label_occupationArr.count > 5 ? 5 * 58 : self.label_occupationArr.count * 58;
                
                listPickerView.title = @"职业";
                listPickerView.dataSourceArr = self.label_occupationArr;
                
                [listPickerView show];
                listPickerView.listPickerViewBlock = ^(VENDataPageModel *model) {
                    self.occupation = model.name;
                    self.occupationID = model.id;
                    
                    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
                };
                [[UIApplication sharedApplication].keyWindow addSubview:listPickerView];
            }
        }
    } else {
        [self.view endEditing:YES];
        
        if (self.label_skinArr.count > 0) {
            VENListPickerView *listPickerView = [[VENListPickerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
            listPickerView.viewHeight = self.label_skinArr.count > 5 ? 5 * 58 : self.label_skinArr.count * 58;
            
            listPickerView.title = @"肤质";
            listPickerView.dataSourceArr = self.label_skinArr;
            
            [listPickerView show];
            listPickerView.listPickerViewBlock = ^(VENDataPageModel *model) {
                self.skin = model.name;
                self.skinID = model.id;
                
                [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:listPickerView];
        }
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
    VENDataTableViewCell *cityCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    
    NSString *constellation_id = @"";
    
    if ([VENEmptyClass isEmptyString:self.constellationID]) {
        if ([self.userInfoModel.constellation_id integerValue] != 0) {
            constellation_id = self.userInfoModel.constellation_id;
        }
    } else {
        constellation_id = self.constellationID;
    }

    NSString *occupation_id = @"";
    
    if ([VENEmptyClass isEmptyString:self.occupationID]) {
        if ([self.userInfoModel.occupation_id integerValue] != 0) {
            occupation_id = self.userInfoModel.occupation_id;
        }
    } else {
        occupation_id = self.occupationID;
    }
    
    NSString *skin_id = @"";
    
    if ([VENEmptyClass isEmptyString:self.skinID]) {
        if ([self.userInfoModel.skin_texture_id integerValue] != 0) {
            skin_id = self.userInfoModel.skin_texture_id;
        }
    } else {
        skin_id = self.skinID;
    }
    
    NSString *gender = @"";
    
    if ([VENEmptyClass isEmptyString:self.genderID]) {
        if ([self.userInfoModel.sex integerValue] != 0) {
            gender = self.userInfoModel.sex;
        }
    } else {
        gender = self.genderID;
    }
    
    NSDictionary *parameters = @{@"name" : nameCell.descriptionTextField.text,
                                 @"birthday" : birthdayCell.descriptionTextField.text,
                                 @"constellation_id" : constellation_id,
                                 @"occupation_id" : occupation_id,
                                 @"address" : cityCell.descriptionTextField.text,
                                 @"skin_texture_id" : skin_id,
                                 @"sex" : gender};
    
    [[VENApiManager sharedManager] modifyUserInfoWithParameters:parameters images:@[iconCell.iconImageView.image] keyName:@"avatar"];
    
    if (self.isPresent) {
        UIViewController *vc = self;
        while (vc.presentingViewController) {
            vc = vc.presentingViewController;
        }
        [vc dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)getAgeWithString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy";
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"%ld岁", [today integerValue] - [[string substringToIndex:4] integerValue]];
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    self.iconImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
