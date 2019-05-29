//
//  VENHomePageSearchResultsViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/22.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSearchResultsViewController.h"
#import "VENExpansionPanelView.h"
#import "VENHomePageSearchResultsTableViewCell.h"
#import "VENPopupView.h"

@interface VENHomePageSearchResultsViewController ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) VENPopupView *popupView;
@property (nonatomic, assign) CGFloat expansionPanelViewHeight;
@property (nonatomic, assign) CGFloat popupViewHeight;
@property (nonatomic, strong) NSMutableArray *buttonSelectedMuArr;
@property (nonatomic, copy) NSDictionary *selectedItem;

@property (nonatomic, strong) NSMutableArray *comprehensiveMuArr;
@property (nonatomic, strong) NSMutableArray *useMuArr;
@property (nonatomic, strong) NSMutableArray *efficacyMuArr;
@property (nonatomic, strong) NSMutableArray *priceMuArr;

@end

static const NSTimeInterval kAnimationDuration = 0.3;
static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENHomePageSearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF8F8F8);
    
    self.expansionPanelViewHeight = 44 + 2;
    self.popupViewHeight = kMainScreenHeight - kStatusBarAndNavigationBarHeight - self.expansionPanelViewHeight;
    
    [self setupTopView];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageSearchResultsTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight + self.expansionPanelViewHeight, kMainScreenWidth, self.popupViewHeight);
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageSearchResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.iconImageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kStatusBarAndNavigationBarHeight + self.expansionPanelViewHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    // 搜索框
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, kStatusBarHeight + 6, kMainScreenWidth - 15 - 55, 32)];
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
    
    // 工具栏
    VENExpansionPanelView *expansionPanelView = [[VENExpansionPanelView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kMainScreenWidth, self.expansionPanelViewHeight)];
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
    [topView addSubview:expansionPanelView];
    
    _topView = topView;
}

- (void)cancelButtonClick {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -  popupView
- (void)show {
    self.popupView.frame = CGRectMake(0, - self.popupViewHeight, kMainScreenWidth, self.popupViewHeight);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.popupView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight + self.expansionPanelViewHeight, kMainScreenWidth, self.popupViewHeight);
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
            popupView.dataSourceArr = self.comprehensiveMuArr;
        } else if (button.tag == 1) {
            popupView.isCollectionView = YES;
            popupView.dataSourceArr = self.useMuArr;
        } else if (button.tag == 2) {
            popupView.isCollectionView = YES;
            popupView.dataSourceArr = self.efficacyMuArr;
        } else {
            popupView.isTableView = YES;
            popupView.dataSourceArr = self.priceMuArr;
        }
        
        popupView.selectedItem = self.selectedItem;
        
        
        __weak typeof(self) weakSelf = self;
        popupView.popupViewBlock = ^(NSDictionary *dict) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdataTitle" object:nil userInfo:dict];
            self.selectedItem = dict;
            [weakSelf.buttonSelectedMuArr removeAllObjects];
            [weakSelf hidden];
            
            [weakSelf.tableView reloadData];
        };
        [self.view addSubview:popupView];
        [self.view bringSubviewToFront:self.topView];
        
        _popupView = popupView;
    }
}

- (NSMutableArray *)buttonSelectedMuArr {
    if (!_buttonSelectedMuArr) {
        _buttonSelectedMuArr = [NSMutableArray array];
    }
    return _buttonSelectedMuArr;
}

- (NSMutableArray *)comprehensiveMuArr {
    if (!_comprehensiveMuArr) {
        _comprehensiveMuArr = [NSMutableArray arrayWithArray:@[@{@"id" : @"1", @"name" : @"A"},
                                                               @{@"id" : @"2", @"name" : @"B"},
                                                               @{@"id" : @"3", @"name" : @"C"},
                                                               @{@"id" : @"4", @"name" : @"D"},
                                                               @{@"id" : @"5", @"name" : @"E"},
                                                               @{@"id" : @"6", @"name" : @"F"},
                                                               @{@"id" : @"7", @"name" : @"G"},
                                                               @{@"id" : @"8", @"name" : @"H"},
                                                               @{@"id" : @"9", @"name" : @"I"},
                                                               @{@"id" : @"10", @"name" : @"J"},
                                                               @{@"id" : @"11", @"name" : @"K"},
                                                               @{@"id" : @"12", @"name" : @"L"},
                                                               @{@"id" : @"13", @"name" : @"M"}]];
    }
    return _comprehensiveMuArr;
}

- (NSMutableArray *)useMuArr {
    if (!_useMuArr) {
        _useMuArr = [NSMutableArray arrayWithArray:@[@{@"id" : @"1", @"name" : @"A2"},
                                                               @{@"id" : @"2", @"name" : @"B2"},
                                                               @{@"id" : @"3", @"name" : @"C2"},
                                                               @{@"id" : @"4", @"name" : @"D2"},
                                                               @{@"id" : @"5", @"name" : @"E2"},
                                                               @{@"id" : @"6", @"name" : @"F2"},
                                                               @{@"id" : @"7", @"name" : @"G2"},
                                                               @{@"id" : @"8", @"name" : @"H2"},
                                                               @{@"id" : @"9", @"name" : @"I2"},
                                                               @{@"id" : @"10", @"name" : @"J2"},
                                                               @{@"id" : @"11", @"name" : @"K2"},
                                                               @{@"id" : @"12", @"name" : @"L2"},
                                                               @{@"id" : @"13", @"name" : @"M2"}]];
    }
    return _useMuArr;
}

- (NSMutableArray *)efficacyMuArr {
    if (!_efficacyMuArr) {
        _efficacyMuArr = [NSMutableArray arrayWithArray:@[@{@"id" : @"1", @"name" : @"A3"},
                                                          @{@"id" : @"2", @"name" : @"B3"},
                                                          @{@"id" : @"3", @"name" : @"C3"},
                                                          @{@"id" : @"4", @"name" : @"D3"},
                                                          @{@"id" : @"5", @"name" : @"E3"},
                                                          @{@"id" : @"6", @"name" : @"F3"},
                                                          @{@"id" : @"7", @"name" : @"G3"},
                                                          @{@"id" : @"8", @"name" : @"H3"},
                                                          @{@"id" : @"9", @"name" : @"I3"},
                                                          @{@"id" : @"10", @"name" : @"3J"},
                                                          @{@"id" : @"11", @"name" : @"3K"},
                                                          @{@"id" : @"12", @"name" : @"3L"},
                                                          @{@"id" : @"13", @"name" : @"3M"}]];
    }
    return _efficacyMuArr;
}

- (NSMutableArray *)priceMuArr {
    if (!_priceMuArr) {
        _priceMuArr = [NSMutableArray arrayWithArray:@[@{@"id" : @"1", @"name" : @"A4"},
                                                       @{@"id" : @"2", @"name" : @"B4"},
                                                       @{@"id" : @"3", @"name" : @"C4"},
                                                       @{@"id" : @"4", @"name" : @"D4"},
                                                       @{@"id" : @"5", @"name" : @"E4"},
                                                       @{@"id" : @"6", @"name" : @"F4"},
                                                       @{@"id" : @"7", @"name" : @"G4"},
                                                       @{@"id" : @"8", @"name" : @"H4"},
                                                       @{@"id" : @"9", @"name" : @"I4"},
                                                       @{@"id" : @"10", @"name" : @"4J"},
                                                       @{@"id" : @"11", @"name" : @"4K"},
                                                       @{@"id" : @"12", @"name" : @"4L"},
                                                       @{@"id" : @"13", @"name" : @"4M"}]];
    }
    return _priceMuArr;
}

- (NSDictionary *)selectedItem {
    if (!_selectedItem) {
        _selectedItem = self.comprehensiveMuArr[0];
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
