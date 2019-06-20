//
//  VENHomePageSearchCompositionDetailCommentDetailPageViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/17.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENCommentDetailPageViewController.h"
#import "VENCommentTableViewCell.h"
#import "VENHomePageSearchCompositionDetailCommentDetailPageHeaderView.h"
#import "VENHomePageSearchCompositionDetailsPageCommentModel.h"

@interface VENCommentDetailPageViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *replyTextField;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (nonatomic, strong) VENHomePageSearchCompositionDetailsPageCommentModel *model;
@property (nonatomic, strong) NSMutableArray *replyMuArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENCommentDetailPageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO; //关闭
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES; //开启
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"评论详情";
    
    self.tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VENCommentTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.replyTextField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self loadDataSource];
    [self setupNavigationItemLeftBarButtonItem];
}

- (void)loadDataSource {
    if ([self.type isEqualToString:@"composition"]) {
        [[VENApiManager sharedManager] searchPageCompositionDetailCommentDetailWithParameters:@{@"id" : self.id} successBlock:^(id  _Nonnull responseObject) {
            
            self.model = responseObject[@"content"];
            self.replyMuArr = [NSMutableArray arrayWithArray:responseObject[@"replyArr"]];
            
            self.replyTextField.placeholder = [NSString stringWithFormat:@"回复%@", self.model.name];
            
            [self.tableView reloadData];
        }];
    } else if ([self.type isEqualToString:@"product"]) {
        [[VENApiManager sharedManager] searchPageProductDetailCommentDetailWithParameters:@{@"id" : self.id} successBlock:^(id  _Nonnull responseObject) {
            
            self.model = responseObject[@"content"];
            self.replyMuArr = [NSMutableArray arrayWithArray:responseObject[@"replyArr"]];
            
            self.replyTextField.placeholder = [NSString stringWithFormat:@"回复%@", self.model.name];
            
            [self.tableView reloadData];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.replyMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.replyMuArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VENHomePageSearchCompositionDetailCommentDetailPageHeaderView *headerView = [[UINib nibWithNibName:@"VENHomePageSearchCompositionDetailCommentDetailPageHeaderView" bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
    headerView.model = self.model;
    headerView.name = self.name;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 300;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

// 键盘弹起 收起
- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    NSDictionary *userInfoDict = notification.userInfo;
    CGRect keyboardFrame = [[userInfoDict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (keyboardFrame.origin.y == kMainScreenHeight) {
        self.inputViewBottomLayoutConstraint.constant = 0;
        self.backgroundButton.hidden = YES;
    } else {
        self.inputViewBottomLayoutConstraint.constant = kIsiPhoneX ? keyboardFrame.size.height - 34 : keyboardFrame.size.height;
        self.backgroundButton.hidden = NO;
    }
}

- (IBAction)backgroundButtonClick:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - 评论
- (IBAction)commentButtonClick:(id)sender {
    if (self.replyTextField.text.length > 0) {
        if ([self.type isEqualToString:@"composition"]) {
            NSDictionary *parameters = @{@"ingredients_id" : self.model.ingredients_id,
                                         @"content" : self.replyTextField.text,
                                         @"pid" : self.model.id};
            [[VENApiManager sharedManager] releaseCompositionCommentWithParameters:parameters images:@[] keyName:@"" successBlock:^(id  _Nonnull responseObject) {
                
                self.replyTextField.text = @"";
                [self.view endEditing:YES];
                [self loadDataSource];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh_Composition_Detail_Page" object:nil];
            }];
        } else if ([self.type isEqualToString:@"product"]) {
            NSDictionary *parameters = @{@"goods_id" : self.model.goods_id,
                                         @"content" : self.replyTextField.text,
                                         @"pid" : self.model.id};
            [[VENApiManager sharedManager] releaseProductCommentWithParameters:parameters images:@[] keyName:@"" successBlock:^(id  _Nonnull responseObject) {
                
                self.replyTextField.text = @"";
                [self.view endEditing:YES];
                [self loadDataSource];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh_Product_Detail_Page" object:nil];
            }];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self commentButtonClick:textField];
    return YES;
}

#pragma mark - back
- (void)setupNavigationItemLeftBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    
    // 防止返回手势失效
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
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
