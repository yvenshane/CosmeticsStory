//
//  VENProductListViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/19.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENProductListViewController.h"
#import "VENHomePageSearchResultsTableViewCell.h"
#import "VENHomePageSearchResultsModel.h"
#import "VENProductDetailViewController.h"
#import "VENRightSideSelectorView.h"

@interface VENProductListViewController ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *contentMuArr;

@property (nonatomic, strong) VENRightSideSelectorView *rightSideSelectorView;

@property (nonatomic, copy) NSArray *label_comprehensiveArr;
@property (nonatomic, copy) NSArray *label_effectArr;
@property (nonatomic, copy) NSArray *label_priceArr;
@property (nonatomic, copy) NSArray *label_purposeArr;

@property (nonatomic, copy) NSString *label_purpose;
@property (nonatomic, copy) NSString *label_effect;
@property (nonatomic, copy) NSString *label_price;
@property (nonatomic, copy) NSString *label_comprehensive;

@end

static const NSTimeInterval kAnimationDuration = 0.3;
static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF8F8F8);
    self.navigationItem.title = self.cat_name;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageSearchResultsTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight);
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataSourceWithPage:@"1"];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataSourceWithPage:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    [self.view addSubview:self.tableView];
    
    [self loadDataSourceWithPage:@"1"];
    
    [self loadLabel];
    
    [self setupNavigationItemRightBarButtonItem];
}

- (void)loadLabel {
    [[VENApiManager sharedManager] searchPageProductListLabelWithSuccessBlock:^(id  _Nonnull responseObject) {
        self.label_comprehensiveArr = responseObject[@"content"][@"label_comprehensive"];
        self.label_effectArr = responseObject[@"content"][@"label_effect"];
        self.label_priceArr = responseObject[@"content"][@"label_price"];
        self.label_purposeArr = responseObject[@"content"][@"label_purpose"];
        
        self.label_comprehensive = self.label_comprehensiveArr.firstObject[@"name"];
        self.label_purpose = @"";
        self.label_effect = @"";
        self.label_price = @"";
    }];
}

- (void)loadDataSourceWithPage:(NSString *)page {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"start" : page,
                                                                                      @"size" : @"10",
                                                                                      @"cat_id" : self.cat_id}];
    
    if (![VENEmptyClass isEmptyString:self.label_comprehensive]) {
        for (NSDictionary *dict in self.label_comprehensiveArr) {
            if ([dict[@"name"] isEqualToString:self.label_comprehensive]) {
                [parameters setObject:dict[@"id"] forKey:@"label_comprehensive"];
            }
        }
    }
    
    if (![VENEmptyClass isEmptyString:self.label_purpose]) {
        for (NSDictionary *dict in self.label_purposeArr) {
            if ([dict[@"name"] isEqualToString:self.label_purpose]) {
                [parameters setObject:dict[@"id"] forKey:@"label_purpose"];
            }
        }
    }
    
    if (![VENEmptyClass isEmptyString:self.label_effect]) {
        for (NSDictionary *dict in self.label_effectArr) {
            if ([dict[@"name"] isEqualToString:self.label_effect]) {
                [parameters setObject:dict[@"id"] forKey:@"label_effect"];
            }
        }
    }
    
    if (![VENEmptyClass isEmptyString:self.label_price]) {
        for (NSDictionary *dict in self.label_priceArr) {
            if ([dict[@"name"] isEqualToString:self.label_price]) {
                [parameters setObject:dict[@"id"] forKey:@"label_price"];
            }
        }
    }
    
    [[VENApiManager sharedManager] searchPageProductListWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
        
        if ([page integerValue] == 1) {
            [self.tableView.mj_header endRefreshing];
            
            self.contentMuArr = [NSMutableArray arrayWithArray:responseObject[@"content"]];
            
            self.page = 1;
        } else {
            [self.tableView.mj_footer endRefreshing];
            
            [self.contentMuArr addObjectsFromArray:responseObject[@"content"]];
        }
        
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageSearchResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.contentMuArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VENHomePageSearchResultsModel *model = self.contentMuArr[indexPath.row];
    
    VENProductDetailViewController *vc = [[VENProductDetailViewController alloc] init];
    vc.goods_id = model.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 121;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - 筛选
- (void)setupNavigationItemRightBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 44)];
    [button setImage:[UIImage imageNamed:@"icon_shaixuan"] forState:UIControlStateNormal];
    [button setTitle:@" 筛选" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [button addTarget:self action:@selector(shuaixuanButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)shuaixuanButtonClick {
    [self.view endEditing:YES];
    [self show];
}

- (void)show {
    self.rightSideSelectorView.frame = CGRectMake(- kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.rightSideSelectorView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    } completion:nil];
}

- (void)hidden {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.rightSideSelectorView.frame = CGRectMake(- kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight);
    } completion:^(BOOL finished) {
        [self.rightSideSelectorView removeFromSuperview];
        self.rightSideSelectorView = nil;
    }];
}

- (VENRightSideSelectorView *)rightSideSelectorView {
    if (!_rightSideSelectorView) {
        _rightSideSelectorView = [[VENRightSideSelectorView alloc] init];
        
        _rightSideSelectorView.dataSource = @{@"label_comprehensiveArr" : self.label_comprehensiveArr,
                                              @"label_purposeArr" : self.label_purposeArr,
                                              @"label_effectArr" : self.label_effectArr,
                                              @"label_priceArr" : self.label_priceArr};
        
        _rightSideSelectorView.comprehensive = self.label_comprehensive;
        _rightSideSelectorView.purpose = self.label_purpose;
        _rightSideSelectorView.effect = self.label_effect;
        _rightSideSelectorView.price = self.label_price;
        
        [_rightSideSelectorView.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        __weak typeof(self) weakSelf = self;
        _rightSideSelectorView.rightSideSelectorViewBlock = ^(NSArray *arr) {
            weakSelf.label_comprehensive = arr[0];
            weakSelf.label_purpose = arr[1];
            weakSelf.label_effect = arr[2];
            weakSelf.label_price = arr[3];
            
            [weakSelf hidden];
            [weakSelf loadDataSourceWithPage:@"1"];
        };
        
        [[UIApplication sharedApplication].keyWindow addSubview:_rightSideSelectorView];
    }
    return _rightSideSelectorView;
}

- (void)closeButtonClick {
    [self hidden];
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
