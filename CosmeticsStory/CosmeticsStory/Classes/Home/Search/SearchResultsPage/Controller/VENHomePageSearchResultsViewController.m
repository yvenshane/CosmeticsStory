//
//  VENHomePageSearchResultsViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/22.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSearchResultsViewController.h"
#import "VENHomePageSearchResultsTableViewCell.h"
#import "VENPopupView.h"
#import "VENHomePageSearchResultsModel.h"
#import "VENProductDetailViewController.h"
#import "VENRightSideSelectorView.h"

@interface VENHomePageSearchResultsViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *contentMuArr;

@property (nonatomic, strong) VENRightSideSelectorView *rightSideSelectorView;

@property (nonatomic, copy) NSArray *label_comprehensiveArr;
@property (nonatomic, copy) NSArray *label_purposeArr;
@property (nonatomic, copy) NSArray *label_effectArr;
@property (nonatomic, copy) NSArray *label_priceArr;

@property (nonatomic, copy) NSString *label_comprehensive;
@property (nonatomic, copy) NSString *label_purpose;
@property (nonatomic, copy) NSString *label_effect;
@property (nonatomic, copy) NSString *label_price;

@end

static const NSTimeInterval kAnimationDuration = 0.3;
static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENHomePageSearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF8F8F8);
    
    [self setupTopView];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageSearchResultsTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight);
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataSourceWithPage:@"1"];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataSourceWithPage:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    [self.view addSubview:self.tableView];
    
    [self loadDataSourceWithPage:@"1"];
    
    [self loadLabel];
}

- (void)loadLabel {
    [[VENApiManager sharedManager] searchPageProductListLabelWithSuccessBlock:^(id  _Nonnull responseObject) {
        self.label_comprehensiveArr = responseObject[@"content"][@"label_comprehensive"];
        self.label_purposeArr = responseObject[@"content"][@"label_purpose"];
        self.label_effectArr = responseObject[@"content"][@"label_effect"];
        self.label_priceArr = responseObject[@"content"][@"label_price"];
        
        self.label_comprehensive = self.label_comprehensiveArr.firstObject[@"name"];
        self.label_purpose = @"";
        self.label_effect = @"";
        self.label_price = @"";
    }];
}

- (void)loadDataSourceWithPage:(NSString *)page {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"start" : page,
                                                                                      @"size" : @"10"}];
    
    if (![VENEmptyClass isEmptyString:self.keyWords]) {
        [parameters setObject:self.keyWords forKey:@"goods_name"];
    }
    
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
    
    if (![VENEmptyClass isEmptyString:self.brand_id]) {
        [parameters setObject:self.brand_id forKey:@"brand_id"];
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
    vc.isPresents = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
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

#pragma mark - 搜索栏
- (void)setupTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kStatusBarAndNavigationBarHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIButton *colButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, 55, 44)];
    [colButton setImage:[UIImage imageNamed:@"icon_shaixuan"] forState:UIControlStateNormal];
    [colButton addTarget:self action:@selector(colButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:colButton];
    
    // 搜索框
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(55, kStatusBarHeight + 6, kMainScreenWidth - 55 - 55, 32)];
    searchTextField.delegate = self;
    searchTextField.text = self.keyWords;
//    searchTextField.delegate = self;
    searchTextField.font = [UIFont systemFontOfSize:12.0f];
    searchTextField.backgroundColor = UIColorFromRGB(0xF5F5F5);
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"搜索200万+化妆品的安全和功效" attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xCCCCCC)}];
    searchTextField.attributedPlaceholder = attrString;
    ViewRadius(searchTextField, 16.0f);
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 32)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 32 / 2 - 12 / 2 - 0.5, 12, 12)];
    imgView.image = [UIImage imageNamed:@"icon_search2"];
    [leftView addSubview:imgView];
    
    searchTextField.leftView = leftView;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.returnKeyType = UIReturnKeySearch;
    
    [topView addSubview:searchTextField];
    
    // 取消
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 55, kStatusBarHeight, 55, 44)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColorFromRGB(0x33333) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelButton];
}

#pragma mark - 筛选
- (void)colButtonClick {
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
        
        [self.view addSubview:_rightSideSelectorView];
    }
    return _rightSideSelectorView;
}

- (void)closeButtonClick {
    [self hidden];
}

#pragma mark - 取消
- (void)cancelButtonClick {
    if (self.isPush) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.keyWords = textField.text;
    
    [self.view endEditing:YES];
    [self loadDataSourceWithPage:@"1"];
    
    return YES;
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
