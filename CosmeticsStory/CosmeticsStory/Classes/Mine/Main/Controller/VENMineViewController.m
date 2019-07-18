//
//  VENMineViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/7.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMineViewController.h"
#import "VENMineTableHeaderView.h"
#import "VENMineTableViewCell.h"
#import "VENDataViewController.h"
#import "VENSettingViewController.h"
#import "VENMessageViewController.h"
#import "VENDataPageModel.h"
#import "VENCosmeticBagModel.h"
#import "VENCosmeticBagPopupViewTwo.h"
#import "VENCosmeticBagDetailViewController.h"
#import "VENFootprintViewController.h"

@interface VENMineViewController ()
@property (nonatomic, strong) VENDataPageModel *userInfoModel;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) NSMutableArray *contentMuArr;
@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) VENCosmeticBagPopupViewTwo *popupView;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isRefresh) {
        [self loadDataSource];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的";
    
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - kTabBarHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMineTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
    
    [self loadDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter) name:@"Login_Out" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter2) name:@"Refresh_Mine_Page" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter3) name:@"Push_To_Classify_Page" object:nil];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataSource];
    }];
}

- (void)notificationCenter3 {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tabBarController.selectedIndex = 1;
    });
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    NSDictionary *userInfoDict = notification.userInfo;
    CGRect keyboardFrame = [[userInfoDict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat width = 300;
    CGFloat height = 44 + 48 + 160;
    
    if (keyboardFrame.origin.y == kMainScreenHeight) {
        self.popupView.frame = CGRectMake(kMainScreenWidth / 2 - width / 2, kMainScreenHeight / 2 - height / 2, width, height);
    } else {
        self.popupView.frame = CGRectMake(kMainScreenWidth / 2 - width / 2, kMainScreenHeight / 2 - height, width, height);
    }
}

- (void)notificationCenter {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isRefresh = YES;
        self.tabBarController.selectedIndex = 0;
    });
}

- (void)notificationCenter2 {
    [self loadDataSource];
}

- (void)loadDataSource {
    [[VENApiManager sharedManager] userInfoWithSuccessBlock:^(id  _Nonnull responseObject) {
        self.userInfoModel = responseObject[@"userInfo"];
        
        [self.tableView.mj_header endRefreshing];
        
        [[VENApiManager sharedManager] detailPageCosmeticBagListWithSuccessBlock:^(id  _Nonnull responseObject) {
            self.contentMuArr = [NSMutableArray arrayWithArray:responseObject[@"content"]];
            
            self.isRefresh = NO;
            [self.tableView reloadData];
        }];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENCosmeticBagModel *model = self.contentMuArr[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    cell.titleLabel.text = model.name;
    cell.descriptionLabel.text = model.descriptionn;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VENCosmeticBagModel *model = self.contentMuArr[indexPath.row];
    
    VENCosmeticBagDetailViewController *vc = [[VENCosmeticBagDetailViewController alloc] init];
    vc.name = model.name;
    vc.id = model.id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VENMineTableHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"VENMineTableHeaderView" owner:nil options:nil].lastObject;
    headerView.model = self.userInfoModel;
    
    [headerView.footprintButton addTarget:self action:@selector(footprintButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView.messageButton addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView.dataButton addTarget:self action:@selector(dataButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView.settingButton addTarget:self action:@selector(settingButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView.addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 317.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - 足迹
- (void)footprintButtonClick {
    VENFootprintViewController *vc = [[VENFootprintViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 消息
- (void)messageButtonClick {
    VENMessageViewController *vc = [[VENMessageViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 资料
- (void)dataButtonClick {
    VENDataViewController *vc = [[VENDataViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 设置
- (void)settingButtonClick {
    VENSettingViewController *vc = [[VENSettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 新增
- (void)addButtonClick {
    UIButton *backgroundButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    backgroundButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    [[UIApplication sharedApplication].keyWindow addSubview:backgroundButton];
    
    CGFloat width = 300;
    CGFloat height = 44 + 48 + 160;
    
    VENCosmeticBagPopupViewTwo *popupView = [[VENCosmeticBagPopupViewTwo alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - width / 2, kMainScreenHeight / 2 - height / 2, width, height)];
    popupView.cosmeticBagPopupViewTwoBlock = ^(NSString *str) {
        [backgroundButton removeFromSuperview];
        
        [self notificationCenter2];
    };
    [popupView.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundButton addSubview:popupView];
    
    _popupView = popupView;
    _backgroundButton = backgroundButton;
}

- (void)closeButtonClick {
    [self.backgroundButton removeFromSuperview];
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
