//
//  VENFootprintViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/25.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENFootprintViewController.h"
// 好文
#import "VENWaterfallFlowViewCollectionViewCell.h"
#import "XRWaterfallLayout.h"
#import "VENHomePageModel.h"
#import "VENHomePageFindDetailViewController.h"
// 评价
#import "VENBaseCategoryView.h"
#import "VENCosmeticBagDetailProductViewController.h"
#import "VENCosmeticBagDetailCompositionViewController.h"

@interface VENFootprintViewController () <UICollectionViewDataSource, UICollectionViewDelegate, XRWaterfallLayoutDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *backgroundView;
// 好文
@property (nonatomic, strong) UICollectionView *collectionVieww;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *contentMuArr;
// 评价
@property (nonatomic, weak) VENBaseCategoryView *categoryView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger pageIdx;

@property (nonatomic, copy) NSArray *goodsListArr;
@property (nonatomic, copy) NSArray *ingredientsListArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENFootprintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationView];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight)];
    [self.view addSubview:backgroundView];
    _backgroundView = backgroundView;
    
    // 好文
    [self setupCollectionView];
    [self loadDataSourceWithPage:@"1"];
}

#pragma merk - 评论
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
    [self.backgroundView addSubview:categoryV];
    
    [categoryV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.width.mas_equalTo(kMainScreenWidth);
        make.height.mas_equalTo(44);
    }];
    
    UIScrollView *scrollV = [self setupContentView];
    [self.backgroundView addSubview:scrollV];
    
    [scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(categoryV);
        make.top.equalTo(categoryV.mas_bottom);
        make.bottom.equalTo(self.backgroundView);
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
    
    NSArray<NSString *> *vcNamesArr = @[@"VENFootprintCommentProductPageViewController", @"VENFootprintCommentCompositionPageViewController"];
    
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

#pragma mark - 好文
- (void)loadDataSourceWithPage:(NSString *)page {
    
    NSDictionary *parameters = @{@"start" : page, @"size" : @"10"};
    [[VENApiManager sharedManager] myFootprintListWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
        
        if ([page integerValue] == 1) {
            [self.collectionVieww.mj_header endRefreshing];
            
            self.contentMuArr = [NSMutableArray arrayWithArray:responseObject];
            
            self.page = 1;
        } else {
            [self.collectionVieww.mj_footer endRefreshing];
            
            [self.contentMuArr addObjectsFromArray:responseObject];
        }
        
        [self.collectionVieww reloadData];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.contentMuArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VENWaterfallFlowViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    VENHomePageModel *model = self.contentMuArr[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    //    cell.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.titileLabel.text = model.title;
    cell.dateLabel.text = model.addtime;
    [cell.likeButton setTitle:[NSString stringWithFormat:@"  %@", model.collectionCount] forState:UIControlStateNormal];
    
    CGFloat width = (kMainScreenWidth - 30 - 40) / 2;
    
    CGFloat imageWidth = [model.imageSize[@"0"] floatValue];
    CGFloat imageHeight = [model.imageSize[@"1"] floatValue];
    
    if (imageWidth > width) {
        imageHeight = imageHeight * (width / imageWidth);
        imageWidth = width;
    }
    
    cell.iconImageViewHeight.constant = imageHeight;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageModel *model = self.contentMuArr[indexPath.row];
    
    VENHomePageFindDetailViewController *vc = [[VENHomePageFindDetailViewController alloc] init];
    vc.goods_id = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    
    VENHomePageModel *model = self.contentMuArr[indexPath.row];
    
    CGFloat width = (kMainScreenWidth - 30 - 40) / 2;
    
    CGFloat imageWidth = [model.imageSize[@"0"] floatValue];
    CGFloat imageHeight = [model.imageSize[@"1"] floatValue];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = model.title;
    label.font = [UIFont systemFontOfSize:14.0f];
    label.numberOfLines = 0;
    CGFloat labelHeight = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height;
    
    if (imageWidth > width) {
        imageHeight = imageHeight * (width / imageWidth);
        imageWidth = width;
    }
    
    return imageHeight + 10 + 12 + labelHeight + 6 + 15 + 12;
}

- (void)setupCollectionView {
    XRWaterfallLayout *waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
    [waterfall setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(0, 10, 10, 10)];
    waterfall.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight) collectionViewLayout:waterfall];
    collectionView.backgroundColor = UIColorFromRGB(0xF6F6F6);
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"VENWaterfallFlowViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [self.backgroundView addSubview:collectionView];
    
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataSourceWithPage:@"1"];
    }];
    
    collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataSourceWithPage:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    _collectionVieww = collectionView;
}

#pragma mark - navigationView
- (void)setupNavigationView {
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 30)];
    ViewBorderRadius(navigationView, 2, 1, COLOR_THEME);
    self.navigationItem.titleView = navigationView;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    leftButton.backgroundColor = COLOR_THEME;
    [leftButton setTitle:@"好文" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 70, 30)];
    rightButton.backgroundColor = [UIColor whiteColor];
    [rightButton setTitle:@"评价" forState:UIControlStateNormal];
    [rightButton setTitleColor:COLOR_THEME forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:rightButton];
    
    _leftButton = leftButton;
    _rightButton = rightButton;
}

- (void)leftButtonClick:(UIButton *)button {
    button.backgroundColor = COLOR_THEME;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.rightButton.backgroundColor = [UIColor whiteColor];
    [self.rightButton setTitleColor:COLOR_THEME forState:UIControlStateNormal];
    
    for (UIView *subview in self.backgroundView.subviews) {
        [subview removeFromSuperview];
    }
    
    [self setupCollectionView];
}

- (void)rightButtonClick:(UIButton *)button {
    button.backgroundColor = COLOR_THEME;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.leftButton.backgroundColor = [UIColor whiteColor];
    [self.leftButton setTitleColor:COLOR_THEME forState:UIControlStateNormal];
    
    for (UIView *subview in self.backgroundView.subviews) {
        [subview removeFromSuperview];
    }
    
    [self setupUI];
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
