//
//  VENProductListViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/19.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENProductListViewController.h"
#import "VENExpansionPanelView.h"
#import "VENHomePageSearchResultsTableViewCell.h"
#import "VENPopupView.h"
#import "VENHomePageSearchResultsModel.h"
#import "VENProductDetailViewController.h"

@interface VENProductListViewController ()
//@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) VENPopupView *popupView;
@property (nonatomic, assign) CGFloat expansionPanelViewHeight;
@property (nonatomic, assign) CGFloat popupViewHeight;
@property (nonatomic, strong) NSMutableArray *buttonSelectedMuArr;
@property (nonatomic, copy) NSDictionary *selectedItem;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *contentMuArr;

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
    
    self.expansionPanelViewHeight = 44 + 2;
    self.popupViewHeight = kMainScreenHeight - kStatusBarAndNavigationBarHeight - self.expansionPanelViewHeight;
    
    [self setupTopView];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageSearchResultsTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0,self.expansionPanelViewHeight, kMainScreenWidth, self.popupViewHeight);
    
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
        self.label_effectArr = responseObject[@"content"][@"label_effect"];
        self.label_priceArr = responseObject[@"content"][@"label_price"];
        self.label_purposeArr = responseObject[@"content"][@"label_purpose"];
    }];
}

- (void)loadDataSourceWithPage:(NSString *)page {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"start" : page,
                                                                                      @"size" : @"10",
                                                                                      @"cat_id" : self.cat_id}];
    
    if (![VENEmptyClass isEmptyString:self.label_purpose]) {
        [parameters setObject:self.label_purpose forKey:@"label_purpose"];
    }
    
    if (![VENEmptyClass isEmptyString:self.label_effect]) {
        [parameters setObject:self.label_effect forKey:@"label_effect"];
    }
    
    if (![VENEmptyClass isEmptyString:self.label_price]) {
        [parameters setObject:self.label_price forKey:@"label_price"];
    }
    
    if (![VENEmptyClass isEmptyString:self.label_comprehensive]) {
        [parameters setObject:self.label_comprehensive forKey:@"label_comprehensive"];
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

#pragma mark - 工具栏
- (void)setupTopView {
    VENExpansionPanelView *expansionPanelView = [[VENExpansionPanelView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.expansionPanelViewHeight)];
    expansionPanelView.widgetMuArr = [NSMutableArray arrayWithArray:@[@"综合", @"用途", @"功效", @"价格"]];
    expansionPanelView.expansionPanelViewBlock = ^(UIButton * button) {
        
        if (![VENEmptyClass isEmptyArray:self.buttonSelectedMuArr]) {
            for (UIButton *btn in self.buttonSelectedMuArr) {
                [self.buttonSelectedMuArr removeAllObjects];
                [self hidden];
                if (button.tag != btn.tag) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.buttonSelectedMuArr addObject:button];
                        [self setupPopupViewWithButton:button];
                        [self show];
                    });
                }
            }
        } else {
            [self.buttonSelectedMuArr addObject:button];
            [self setupPopupViewWithButton:button];
            [self show];
        }
    };
    [self.view addSubview:expansionPanelView];
}

- (void)cancelButtonClick {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -  popupView
- (void)show {
    self.popupView.frame = CGRectMake(0, - self.popupViewHeight, kMainScreenWidth, self.popupViewHeight);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.popupView.frame = CGRectMake(0, self.expansionPanelViewHeight, kMainScreenWidth, self.popupViewHeight);
    } completion:nil];
}

- (void)hidden {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.popupView.frame = CGRectMake(0, - self.popupViewHeight, kMainScreenWidth, self.popupViewHeight);
    } completion:^(BOOL finished) {
        [self.popupView removeFromSuperview];
        self.popupView = nil;
    }];
}

- (void)setupPopupViewWithButton:(UIButton *)button {
    if (!_popupView) {
        VENPopupView *popupView = [[VENPopupView alloc] init];
        
        if (button.tag == 0) {
            popupView.isTableView = YES;
            popupView.dataSourceArr = self.label_comprehensiveArr;
        } else if (button.tag == 1) {
            popupView.isCollectionView = YES;
            popupView.dataSourceArr = self.label_purposeArr;
        } else if (button.tag == 2) {
            popupView.isCollectionView = YES;
            popupView.dataSourceArr = self.label_effectArr;
        } else {
            popupView.isTableView = YES;
            popupView.dataSourceArr = self.label_priceArr;
        }
        
        popupView.selectedItem = self.selectedItem;
        
        
        __weak typeof(self) weakSelf = self;
        popupView.popupViewBlock = ^(NSDictionary *dict) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdataTitle" object:nil userInfo:dict];
            self.selectedItem = dict;
            [weakSelf.buttonSelectedMuArr removeAllObjects];
            [weakSelf hidden];
            
            self.label_comprehensive = @"";
            self.label_purpose = @"";
            self.label_effect = @"";
            self.label_price = @"";
            
            if (button.tag == 0) {
                self.label_comprehensive = dict[@"id"];
            } else if (button.tag == 1) {
                self.label_purpose = dict[@"id"];
            } else if (button.tag == 2) {
                self.label_effect = dict[@"id"];
            } else {
                self.label_price = dict[@"id"];
            }
            
            [self loadDataSourceWithPage:@"1"];
            
            [weakSelf.tableView reloadData];
        };
        [self.view addSubview:popupView];
        
        _popupView = popupView;
    }
}

- (NSMutableArray *)buttonSelectedMuArr {
    if (!_buttonSelectedMuArr) {
        _buttonSelectedMuArr = [NSMutableArray array];
    }
    return _buttonSelectedMuArr;
}

- (NSDictionary *)selectedItem {
    if (!_selectedItem) {
        _selectedItem = self.label_comprehensiveArr[0];
    }
    return _selectedItem;
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
