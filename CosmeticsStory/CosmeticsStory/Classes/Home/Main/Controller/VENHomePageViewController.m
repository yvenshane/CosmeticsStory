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
#import "VENHomePageModel.h"
#import "VENHomePageCouponViewController.h"
#import "VENHomePageFindViewController.h"
#import "VENProductDetailViewController.h"
#import "VENHomePageFindDetailViewController.h"

@interface VENHomePageViewController () <UITextFieldDelegate>
@property (nonatomic, copy) NSArray *bannerListArr;
@property (nonatomic, copy) NSArray *catListArr;
@property (nonatomic, copy) NSArray *recommendListArr;
@property (nonatomic, copy) NSArray *goodsNewsListArr;

@property (nonatomic, assign) CGFloat footerViewHeight;
@property (nonatomic, assign) BOOL isRefresh;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
static NSString *const cellIdentifier2 = @"cellIdentifier2";
@implementation VENHomePageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.barTintColor = COLOR_THEME;
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![[VENUserStatusManager sharedManager] isLogin]) {
        VENInitialPageViewController *vc = [[VENInitialPageViewController alloc] init];
        [self presentViewController:vc animated:NO completion:nil];
    }
    
    self.view.autoresizesSubviews = YES;
    
    [self setupSearchView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageTableViewPopularRecommendCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
//    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageTableViewPopularRecommendCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataSource];
    }];
    
    [self.view addSubview:self.tableView];
    
    [self loadDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"HEIGHT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter1:) name:@"Find_Detail_Page" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter2:) name:@"Image_Button" object:nil];
}

// 发现高度
- (void)notificationCenter:(NSNotification *)noti {
    self.footerViewHeight = [noti.userInfo[@"height"] floatValue];
    
    if (self.footerViewHeight > 10) {
        if (!self.isRefresh) {
            [self.tableView reloadData];
            self.isRefresh = YES;
        }
    }
}

// 发现
- (void)notificationCenter1:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    
    VENHomePageFindDetailViewController *vc = [[VENHomePageFindDetailViewController alloc] init];
    vc.goods_id = dict[@"goods_id"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 图文
- (void)notificationCenter2:(NSNotification *)noti {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tabBarController.selectedIndex = 1;
    });
}

- (void)loadDataSource {
    
    self.isRefresh = NO;
    
    [[VENApiManager sharedManager] homePageWithSuccessBlock:^(id  _Nonnull responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        
        self.bannerListArr = responseObject[@"bannerList"];
        self.catListArr = responseObject[@"catList"];
        self.recommendListArr = responseObject[@"recommendList"];
        self.goodsNewsListArr = responseObject[@"goodsNewsList"];
        
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageTableViewPopularRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    VENHomePageModel *model = self.recommendListArr[indexPath.section];
    cell.model = model;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageModel *model = self.recommendListArr[indexPath.section];
    
    VENProductDetailViewController *vc = [[VENProductDetailViewController alloc] init];
    vc.goods_id = model.goods_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VENHomePageTableHeaderView *headerView = [[VENHomePageTableHeaderView alloc] init];
    headerView.bannerListArr = self.bannerListArr;
    headerView.catListArr = self.catListArr;
    headerView.homePageTableHeaderViewBlock = ^(NSString *str, NSString *goods_id) {
        
        if ([str isEqualToString:@"coupon"]) {
            VENHomePageCouponViewController *vc = [[VENHomePageCouponViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([str isEqualToString:@"find"]) {
            VENHomePageFindViewController *vc = [[VENHomePageFindViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([str isEqualToString:@"banner"]) {
            VENProductDetailViewController *vc = [[VENProductDetailViewController alloc] init];
            vc.goods_id = goods_id;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 + kMainScreenHeight / (667.0 / 140.0) + 111 + 76 + 20 + 10 + 65;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    VENHomePageTableFooterView *footerView = [[VENHomePageTableFooterView alloc] init];
    footerView.goodsNewsListArr = self.goodsNewsListArr;
    footerView.footerViewHeight = self.footerViewHeight;
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.footerViewHeight + 75;
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
