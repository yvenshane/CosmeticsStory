//
//  VENHomePageSearchViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/21.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSearchViewController.h"
#import "VENBaseCategoryView.h"
#import "VENHomePageSearchResultsViewController.h"

@interface VENHomePageSearchViewController () <UITextFieldDelegate, UIScrollViewDelegate>
@property (nonatomic, weak) VENBaseCategoryView *categoryView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger pageIdx;

@end

@implementation VENHomePageSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF8F8F8);
    
    [self setupSearchView];
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"pushSearchResultPage" object:nil];
}

- (void)notificationCenter:(NSNotification *)noti {
    VENHomePageSearchResultsViewController *vc = [[VENHomePageSearchResultsViewController alloc] init];
    vc.keyWords = noti.userInfo[@"keyword"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!(scrollView.isDragging || scrollView.isDecelerating || scrollView.isTracking)) {
        return;
    }
    
    // 获取滚动视图的内容的偏移量 x
    CGFloat offsetX = scrollView.contentOffset.x;
    NSLog(@"%f____%f", offsetX, kMainScreenWidth);
    // 需要将偏移量交给分类视图!
    _categoryView.offset_X = offsetX / 2;
    
    // 计算滚动
    //    NSInteger idx = offsetX / 4 / _categoryView.btnsArr[0].bounds.size.width + 0.5;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    _pageIdx = offsetX / kMainScreenWidth;
    
    // 滚动 加载数据
    if (_pageIdx == 0) {
        
    }
}

- (void)categoryViewValueChanged:(VENBaseCategoryView *)sender {
    
    // 1.获取页码数
    NSUInteger pageNumber = sender.pageNumber;
    _pageIdx = pageNumber;
    // 2.让scrollView滚动
    CGRect rect = CGRectMake(_scrollView.bounds.size.width * pageNumber, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    [_scrollView scrollRectToVisible:rect animated:YES];
    
    // 点击 加载数据
    if (_pageIdx == 0) {
        
    }
}

- (void)setupUI {
    VENBaseCategoryView *categoryV = [[VENBaseCategoryView alloc] initWithFrame:CGRectZero andTitles:@[@"产品", @"成分"]];
    categoryV.backgroundColor = [UIColor whiteColor];
    [categoryV addTarget:self action:@selector(categoryViewValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:categoryV];
    
    [categoryV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(kStatusBarAndNavigationBarHeight + 1);
        make.width.mas_equalTo(kMainScreenWidth);
        make.height.mas_equalTo(44);
    }];
    
    UIScrollView *scrollV = [self setupContentView];
    [self.view addSubview:scrollV];
    
    [scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(categoryV);
        make.top.equalTo(categoryV.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    _categoryView = categoryV;
    _scrollView = scrollV;
}

// 负责创建底部滚动视图的方法
- (UIScrollView *)setupContentView {
    
    UIScrollView *scrollV = [[UIScrollView alloc] init];
    scrollV.backgroundColor = [UIColor whiteColor];
    scrollV.pagingEnabled = YES;
    scrollV.delegate = self;
    
    NSArray<NSString *> *vcNamesArr = @[@"VENHomePageSearchProductViewController", @"VENHomePageSearchCompositionViewController"];
    
    NSMutableArray<UIView *> *vcViewsArrM = [NSMutableArray array];
    
    [vcNamesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 2.1 创建vc对象
        Class cls = NSClassFromString(obj);
        UIViewController *vc = [[cls alloc] init];
        
        // 2.2 建立控制器的父子关系
        [self addChildController:vc intoView:scrollV];
        
        // 2.3添加控制器的视图到view中
        [vcViewsArrM addObject:vc.view];
        
    }];
    
    [vcViewsArrM mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [vcViewsArrM mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(scrollV);
        // 确定内容的高度
        make.bottom.top.equalTo(scrollV);
        
    }];
    
    return scrollV;
}

- (void)addChildController:(UIViewController *)childController intoView:(UIView *)view  {
    
    // 添加子控制器 － 否则响应者链条会被打断，导致事件无法正常传递，而且错误非常难改！
    [self addChildViewController:childController];
    
    // 添加子控制器的视图
    [view addSubview:childController.view];
    
    // 完成子控制器的添加
    [childController didMoveToParentViewController:self];
}

#pragma mark - 搜索栏
- (void)setupSearchView {
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kStatusBarAndNavigationBarHeight)];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, kStatusBarHeight + 6, kMainScreenWidth - 15 - 55, 32)];
    searchTextField.delegate = self;
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
    
    [navigationView addSubview:searchTextField];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 55, kStatusBarHeight, 55, 44)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColorFromRGB(0x33333) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:cancelButton];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![VENEmptyClass isEmptyString:textField.text]) {
        
        if (self.pageIdx == 0) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *tempMuArr = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"SearchResults"]];
            if (![tempMuArr containsObject:textField.text]) {
                [tempMuArr addObject:textField.text];
            }
            [userDefaults setObject:tempMuArr forKey:@"SearchResults"];
            
            VENHomePageSearchResultsViewController *vc = [[VENHomePageSearchResultsViewController alloc] init];
            vc.keyWords = textField.text;
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOAD_DATASOURCE" object:nil userInfo:@{@"keyword" : textField.text}];
            [self.view endEditing:YES];
        }
    }
    return YES;
}

- (void)cancelButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
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
