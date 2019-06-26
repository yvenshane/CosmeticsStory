//
//  VENProductDetailPageAllCompositionViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/26.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENProductDetailPageAllCompositionViewController.h"
#import "VENProductDetailPageAllCompositionTableViewCell.h"
#import "VENProductDetailPageAllCompositionTableHeaderView.h"
#import "VENHomePageSearchCompositionDetailsPageViewController.h"
#import "VENProductDetailPageAllCompositionModel.h"
#import "VENPopupView.h"
#import "VENExpansionPanelView.h"

@interface VENProductDetailPageAllCompositionViewController ()
@property (nonatomic, strong) NSArray *contentArr;

@property (nonatomic, copy) NSArray *totalArr;
@property (nonatomic, copy) NSArray *riskArr;
@property (nonatomic, copy) NSArray *effectArr;

@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *risk_id;
@property (nonatomic, copy) NSString *effect_id;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) VENExpansionPanelView *expansionPanelView;
@property (nonatomic, strong) VENPopupView *popupView;
@property (nonatomic, strong) NSMutableArray *buttonSelectedMuArr;

@property (nonatomic, copy) NSDictionary *selectedItem;

@end

static const NSTimeInterval kAnimationDuration = 0.3;
static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENProductDetailPageAllCompositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"全成分表";
    
    self.total = @"1";
    self.risk_id = @"";
    self.effect_id = @"";
    
    [self setupHeaderView];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"VENProductDetailPageAllCompositionTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 44, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 44);
    [self.view addSubview:self.tableView];
    
    [[VENApiManager sharedManager] searchPageProductDetailAllCompositionPageLabelWithSuccessBlock:^(id  _Nonnull responseObject) {
        
        self.effectArr = responseObject[@"effect"];
        self.riskArr = responseObject[@"risk"];
        self.totalArr = responseObject[@"total"];
        
        [self loadDataSource];
    }];
}

- (void)loadDataSource {
    NSDictionary *parameters = @{@"goods_id" : self.goods_id,
                                 @"total" : self.total,
                                 @"risk_id" : self.risk_id,
                                 @"effect_id" : self.effect_id};
    
    [[VENApiManager sharedManager] searchPageProductDetailAllCompositionPageWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
        
        self.contentArr = responseObject[@"content"];
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENProductDetailPageAllCompositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = self.contentArr[indexPath.row];
    cell.backgroundColor = indexPath.row % 2 == 0 ? UIColorFromRGB(0xF8F8F8) : [UIColor whiteColor];
    
    cell.nameButton.tag = indexPath.row;
    [cell.nameButton addTarget:self action:@selector(nameButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)nameButtonClick:(UIButton *)button {
    VENProductDetailPageAllCompositionModel *model = self.contentArr[button.tag];
    
    VENHomePageSearchCompositionDetailsPageViewController *vc = [[VENHomePageSearchCompositionDetailsPageViewController alloc] init];
    vc.ingredients_id = model.ingredients_id;
    vc.isPresent = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VENProductDetailPageAllCompositionTableHeaderView *headerView = [[UINib nibWithNibName:@"VENProductDetailPageAllCompositionTableHeaderView" bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
    headerView.count = self.contentArr.count;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 135;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark -  headerView
- (void)setupHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    // 工具栏
    VENExpansionPanelView *expansionPanelView = [[VENExpansionPanelView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    expansionPanelView.expansionPanelViewStyle = @"AllComposition";
    expansionPanelView.widgetMuArr = [NSMutableArray arrayWithArray:@[@"全成分表", @"安全指数", @"功效分类"]];
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
    [headerView addSubview:expansionPanelView];
    
    _headerView = headerView;
}

#pragma mark -  popupView
- (void)show {
    self.popupView.frame = CGRectMake(0, - (kMainScreenHeight - 45), kMainScreenWidth, kMainScreenHeight - 45);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.popupView.frame = CGRectMake(0, 45, kMainScreenWidth, kMainScreenHeight - 45);
    } completion:nil];
}

- (void)hidden {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.popupView.frame = CGRectMake(0, - (kMainScreenHeight - 45), kMainScreenWidth, kMainScreenHeight - 45);
    } completion:^(BOOL finished) {
        [self.popupView removeFromSuperview];
        self.popupView = nil;
    }];
}

- (void)buttonClick:(UIButton *)button {
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
}

- (void)setupPopupViewWithButton:(UIButton *)button {
    if (!_popupView) {
        VENPopupView *popupView = [[VENPopupView alloc] init];
        
        popupView.popupViewStyle = @"collectionView2";
        if (button.tag == 0) {
            popupView.dataSourceArr = self.totalArr;
        } else if (button.tag == 1) {
            popupView.dataSourceArr = self.riskArr;
        } else if (button.tag == 2) {
            popupView.dataSourceArr = self.effectArr;
        }
        
        popupView.selectedItem = self.selectedItem;
        
        __weak typeof(self) weakSelf = self;
        popupView.popupViewBlock = ^(NSDictionary *dict) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdataTitle" object:nil userInfo:dict];
            self.selectedItem = dict;
            [weakSelf.buttonSelectedMuArr removeAllObjects];
            [weakSelf hidden];
            
            self.total = @"";
            self.risk_id = @"";
            self.effect_id = @"";
            
            if (button.tag == 0) {
                self.total = dict[@"id"];
            } else if (button.tag == 1) {
                self.risk_id = dict[@"id"];
            } else {
                self.effect_id = dict[@"id"];
            }
            
            [self loadDataSource];
            
            [weakSelf.tableView reloadData];
        };
        [self.view addSubview:popupView];
        [self.view bringSubviewToFront:self.headerView];
        
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
        _selectedItem = self.totalArr[0];
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
