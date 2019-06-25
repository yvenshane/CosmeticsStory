//
//  VENCosmeticBagDetailViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/25.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENCosmeticBagDetailViewController.h"
#import "VENBaseCategoryView.h"
#import "VENCosmeticBagDetailProductViewController.h"
#import "VENCosmeticBagDetailCompositionViewController.h"

@interface VENCosmeticBagDetailViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) VENBaseCategoryView *categoryView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger pageIdx;

@property (nonatomic, copy) NSArray *goodsListArr;
@property (nonatomic, copy) NSArray *ingredientsListArr;

@end

@implementation VENCosmeticBagDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.name;
    
    [self loadDataSource];
    [self setupRightButton];
}

- (void)loadDataSource {
    [[VENApiManager sharedManager] myCosmeticBagDetailPageWithParameters:@{@"cat_id" : self.id} SuccessBlock:^(id  _Nonnull responseObject) {
        
        self.goodsListArr = responseObject[@"content"][@"goodsList"];
        self.ingredientsListArr = responseObject[@"content"][@"ingredientsList"];
        [self setupHeaderViewWithContent:responseObject[@"content"][@"descriptionn"]];
    }];
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

- (void)setupUIWithHeight:(CGFloat)height {
    VENBaseCategoryView *categoryV = [[VENBaseCategoryView alloc] initWithFrame:CGRectZero andTitles:@[@"产品", @"成分"]];
    categoryV.backgroundColor = [UIColor whiteColor];
    [categoryV addTarget:self action:@selector(categoryViewValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:categoryV];
    
    [categoryV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(height);
        make.width.mas_equalTo(kMainScreenWidth);
        make.height.mas_equalTo(44);
    }];
    
    UIScrollView *scrollV = [self setupContentViewWithHeight:height];
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
- (UIScrollView *)setupContentViewWithHeight:(CGFloat)height {
    
    UIScrollView *scrollV = [[UIScrollView alloc] init];
    scrollV.backgroundColor = [UIColor whiteColor];
    scrollV.pagingEnabled = YES;
    scrollV.delegate = self;
    
    NSMutableArray<UIView *> *vcViewsArrM = [NSMutableArray array];
    
    VENCosmeticBagDetailProductViewController *vc = [[VENCosmeticBagDetailProductViewController alloc] init];
    vc.headerViewHeight = height;
    vc.goodsListArr = self.goodsListArr;
    [self addChildController:vc intoView:scrollV];
    [vcViewsArrM addObject:vc.view];
    
    VENCosmeticBagDetailCompositionViewController *vc2 = [[VENCosmeticBagDetailCompositionViewController alloc] init];
    vc2.headerViewHeight = height;
    vc2.ingredientsListArr = self.ingredientsListArr;
    [self addChildController:vc2 intoView:scrollV];
    [vcViewsArrM addObject:vc2.view];
    
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

- (void)setupHeaderViewWithContent:(NSString *)content {
    
    if ([VENEmptyClass isEmptyString:content]) {
        [self setupUIWithHeight:0];
    } else {
        UILabel *label = [[UILabel alloc] init];
        label.text = content;
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:14.0f];
        
        CGFloat height = [label sizeThatFits:CGSizeMake(kMainScreenWidth - 30, CGFLOAT_MAX)].height;
        label.frame = CGRectMake(15, 15, kMainScreenWidth - 30, height);
        [self.view addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height + 30, kMainScreenWidth, 10)];
        lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self.view addSubview:lineView];
        
        [self setupUIWithHeight:height + 30 + 10];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, height + 30 + 10 + 44, kMainScreenWidth, 1)];
        lineView2.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self.view addSubview:lineView2];
    }
}

#pragma mark - NavigationItem right
- (void)setupRightButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"icon_add2"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)pushButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Push_To_Classify_Page" object:nil];
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
