//
//  VENHomePageViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/7.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageViewController.h"
#import "VENInitialPageViewController.h"
#import "VENHomePageTableHeaderView.h"
#import "VENHomePageTableFooterView.h"
#import "VENHomePageTableViewPopularRecommendCell.h"
#import "VENHomePageSearchViewController.h"

@interface VENHomePageViewController () <UITextFieldDelegate>

@end

static NSString *const cellIdentifier = @"cellIdentifier";
static NSString *const cellIdentifier2 = @"cellIdentifier2";
@implementation VENHomePageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = COLOR_THEME;
    
    VENInitialPageViewController *vc = [[VENInitialPageViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
    
    [self setupSearchView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageTableViewPopularRecommendCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
//    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageTableViewPopularRecommendCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageTableViewPopularRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.iconImageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VENHomePageTableHeaderView *headerView = [[VENHomePageTableHeaderView alloc] init];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 + kMainScreenHeight / (667.0 / 140.0) + 111 + 76 + 20 + 10 + 65;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    VENHomePageTableFooterView *footerView = [[VENHomePageTableFooterView alloc] init];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 500;
}

#pragma mark - 顶部搜索框
- (void)setupSearchView {
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 30, 32)];
    searchTextField.delegate = self;
    searchTextField.font = [UIFont systemFontOfSize:12.0f];
    searchTextField.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.31];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"搜索200万+化妆品的安全和功效" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    searchTextField.attributedPlaceholder = attrString;
    ViewRadius(searchTextField, 16.0f);

    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 32)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 32 / 2 - 12 / 2 - 0.5, 12, 12)];
    imgView.image = [UIImage imageNamed:@"icon_search"];
    [leftView addSubview:imgView];
    
    searchTextField.leftView = leftView;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.navigationItem.titleView = searchTextField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    VENHomePageSearchViewController *vc = [[VENHomePageSearchViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
    return NO;
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
