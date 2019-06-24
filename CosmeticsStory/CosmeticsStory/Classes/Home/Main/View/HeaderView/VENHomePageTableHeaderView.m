//
//  VENHomePageTableHeaderView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/16.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageTableHeaderView.h"
#import "VENHomePageBannerCollectionViewCell.h"
#import "VENHomePageHeaderViewButton.h"
#import "VENHomePageHeaderViewScrollView.h"
#import "VENHomePageModel.h"

@interface VENHomePageTableHeaderView () <TYCyclePagerViewDelegate, TYCyclePagerViewDataSource, VENHomePageHeaderViewScrollViewDelegate>
@property (nonatomic, strong) UIImageView *bannerBackgroundView;
@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;

@property (nonatomic, strong) UIButton *couponButton;
@property (nonatomic, strong) UIButton *findButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) VENHomePageHeaderViewScrollView *scrollView;

@end

static NSString *const bannerCellIdentifier = @"bannerCellIdentifier";
@implementation VENHomePageTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // banner 背景渐变图
        UIImageView *bannerBackgroundView = [[UIImageView alloc] init];
        bannerBackgroundView.image = [UIImage imageNamed:@"icon_bannerBG"];
        [self addSubview:bannerBackgroundView];
        
        TYCyclePagerView *pagerView = [[TYCyclePagerView alloc] init];
        pagerView.isInfiniteLoop = YES;
        pagerView.autoScrollInterval = 3.0;
        pagerView.dataSource = self;
        pagerView.delegate = self;
        [pagerView registerNib:[UINib nibWithNibName:@"VENHomePageBannerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:bannerCellIdentifier];
        [self addSubview:pagerView];
        
        TYPageControl *pageControl = [[TYPageControl alloc] init];
        pageControl.pageIndicatorSize = CGSizeMake(8, 8);
        pageControl.currentPageIndicatorSize = CGSizeMake(8, 8);
        pageControl.pageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.31];
        [pagerView addSubview:pageControl];
        
        // 优惠券
        UIButton *couponButton = [[UIButton alloc] init];
        [couponButton setImage:[UIImage imageNamed:@"icon_coupon"] forState:UIControlStateNormal];
        [couponButton addTarget:self action:@selector(couponButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:couponButton];
        
        // 发现
        UIButton *findButton = [[UIButton alloc] init];
        [findButton setImage:[UIImage imageNamed:@"icon_find"] forState:UIControlStateNormal];
        [findButton addTarget:self action:@selector(findButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:findButton];
        
        // 分割线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xF8F8F8);
        [self addSubview:lineView];
        
        // title
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"热门推荐";
        titleLabel.textColor = UIColorFromRGB(0x333333);
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [self addSubview:titleLabel];
        
        _bannerBackgroundView = bannerBackgroundView;
        _pagerView = pagerView;
        _pageControl = pageControl;
        _couponButton = couponButton;
        _findButton = findButton;
        _lineView = lineView;
        _titleLabel = titleLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat y = 0;
    self.bannerBackgroundView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight / (667.0 / 120.0));
    self.pagerView.frame = CGRectMake(0, 10, kMainScreenWidth, kMainScreenHeight / (667.0 / 140.0));
    self.pageControl.frame = CGRectMake(0, kMainScreenHeight / (667.0 / 140.0) - 8 - 10, kMainScreenWidth, 8);
    y = kMainScreenHeight / (667.0 / 140.0) + 10;
    
    y = y + 111;
    CGFloat buttonWidth = (kMainScreenWidth - 15 * 3) / 2;
    self.couponButton.frame = CGRectMake(15, y, buttonWidth, 76);
    self.findButton.frame = CGRectMake(15 + buttonWidth + 15, y, buttonWidth, 76);
    y = y + 76;
    
    self.lineView.frame = CGRectMake(0, y + 20, kMainScreenWidth, 10);
    self.titleLabel.frame = CGRectMake(15, y + 10 + 20, kMainScreenWidth - 30, 65);
}

- (void)buttonUpInsideWithView:(UIButton *)btn withIndex:(NSInteger)index withView:(VENHomePageHeaderViewScrollView *)view {
    
    VENHomePageModel *model = self.catListArr[index];
    
    NSDictionary *dict = @{@"cat_id" : model.cat_id,
                           @"cat_name" : model.cat_name};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Image_Button" object:nil userInfo:dict];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"Image_Button"];
}

- (void)setCatListArr:(NSArray *)catListArr {
    _catListArr = catListArr;
    
    if ([VENEmptyClass isEmptyArray:catListArr]) {
        return;
    }
    
    // 图文按钮
    NSMutableArray *views = [NSMutableArray array];
    
    for (int i = 0; i < catListArr.count; i++) {
        
        VENHomePageModel *model = catListArr[i];
        
        VENHomePageHeaderViewButton *btn = [[VENHomePageHeaderViewButton alloc] initWithFrame:CGRectZero setTitle:model.cat_name setImageName:model.cat_image setButtonImageWidth:30.0f setImageTitleSpace:5.0f setButtonTitleLabelFontSize:11.0f];
        [views addObject:btn];
    }
    
    VENHomePageHeaderViewScrollView *scrollView = [[VENHomePageHeaderViewScrollView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight / (667.0 / 140.0) + 10, kMainScreenWidth, 111) viewsArray:views maxCount:5 lineMaxCount:5 pageControlIsShow:YES];
    scrollView.delegate = self;
    [self addSubview:scrollView];
    
    _scrollView = scrollView;
}

- (void)setBannerListArr:(NSArray *)bannerListArr {
    _bannerListArr = bannerListArr;
    
    self.pageControl.numberOfPages = bannerListArr.count;
}

#pragma mark - TYCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.bannerListArr.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    VENHomePageBannerCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:bannerCellIdentifier forIndex:index];
    VENHomePageModel *model = self.bannerListArr[index];
    [cell.bannerImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    cell.bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(kMainScreenWidth - 50, CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 10;
    layout.layoutType = TYCyclePagerTransformLayoutLinear;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    
    VENHomePageModel *model = self.bannerListArr[index];
    self.homePageTableHeaderViewBlock(@"banner", model.goods_id);
}

#pragma mark - 优惠券/发现
- (void)couponButtonClick {
    self.homePageTableHeaderViewBlock(@"coupon", @"");
}

- (void)findButtonClick {
    self.homePageTableHeaderViewBlock(@"find", @"");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
