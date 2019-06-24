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

@interface VENMineViewController ()
@property (nonatomic, strong) VENDataPageModel *userInfoModel;
@property (nonatomic, assign) BOOL isRefresh;

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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMineTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
    
    [self loadDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter) name:@"Login_Out" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter2) name:@"Refresh_Mine_Page" object:nil];
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
        
        self.isRefresh = NO;
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VENMineTableHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"VENMineTableHeaderView" owner:nil options:nil].lastObject;
    headerView.model = self.userInfoModel;
    
    [headerView.messageButton addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView.dataButton addTarget:self action:@selector(dataButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView.settingButton addTarget:self action:@selector(settingButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 317.0f;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
