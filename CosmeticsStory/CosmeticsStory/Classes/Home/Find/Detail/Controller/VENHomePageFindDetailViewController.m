//
//  VENHomePageFindDetailViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageFindDetailViewController.h"
#import "VENHomePageFindDetailModel.h"
#import "VENHomePageFindDetailBottomToolBarView.h"

@interface VENHomePageFindDetailViewController ()
@property (nonatomic, strong) VENHomePageFindDetailModel *contentModel;
@property (nonatomic, strong) VENHomePageFindDetailModel *goodsInfoModel;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) VENHomePageFindDetailBottomToolBarView *bottomToolBar;

@end

@implementation VENHomePageFindDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"详情";
    
    [self loadDataSource];
}

- (void)loadDataSource {
    [[VENApiManager sharedManager] findPageDetailWithParameters:@{@"id" : self.goods_id} successBlock:^(id  _Nonnull responseObject) {
        
        self.contentModel = responseObject[@"content"];
        self.goodsInfoModel = responseObject[@"goodsInfo"];
        
        self.bottomToolBar.titleLabel.text = self.goodsInfoModel.goods_name;
        [self.bottomToolBar.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.goodsInfoModel.goods_thumb]];
        self.bottomToolBar.numberLabel.text = self.goodsInfoModel.fraction;
        self.bottomToolBar.priceLabel.text = [NSString stringWithFormat:@"参考价：%@", self.goodsInfoModel.price];
        [self showStarsWithNumber:self.goodsInfoModel.fraction];
        
        [self.bottomToolBar.colButton setTitle:[NSString stringWithFormat:@"  收藏%@", self.contentModel.collectionCount] forState:UIControlStateNormal];
        self.bottomToolBar.colButton.selected = [self.contentModel.userCollection integerValue] == 0 ? NO : YES;
        
        [self.webView loadHTMLString:self.contentModel.content baseURL:nil];
    }];
}

- (VENHomePageFindDetailBottomToolBarView *)bottomToolBar {
    if (!_bottomToolBar) {
        _bottomToolBar = [[NSBundle mainBundle] loadNibNamed:@"VENHomePageFindDetailBottomToolBarView" owner:nil options:nil].lastObject;
        _bottomToolBar.frame = CGRectMake(0, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 178 - (kTabBarHeight - 49), kMainScreenWidth, 178);
        _bottomToolBar.backgroundColor = [UIColor whiteColor];
        [_bottomToolBar.colButton addTarget:self action:@selector(colButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bottomToolBar];
    }
    return _bottomToolBar;
}

- (void)colButtonClick:(UIButton *)button {
    [[VENApiManager sharedManager] goodsNewsCollectionWithParameters:@{@"id" : self.contentModel.id} successBlock:^(id  _Nonnull responseObject) {
        
        if (button.selected) {
            self.contentModel.collectionCount = [NSString stringWithFormat:@"%ld", [self.contentModel.collectionCount integerValue] - 1];
        } else {
            self.contentModel.collectionCount = [NSString stringWithFormat:@"%ld", [self.contentModel.collectionCount integerValue] + 1];
        }
        
        [self.bottomToolBar.colButton setTitle:[NSString stringWithFormat:@"  收藏%@", self.contentModel.collectionCount] forState:UIControlStateNormal];
        
        button.selected = !button.selected;
    }];
}

- (void)showStarsWithNumber:(NSString *)number {
    
    for (UIView *subview in self.bottomToolBar.starsView.subviews) {
        [subview removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < [number integerValue]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (12 + 6), 0, 12, 12)];
        imageView.image = [UIImage imageNamed:@"icon_star4"];
        [self.bottomToolBar.starsView addSubview:imageView];
    }
    
    if ([number floatValue] > [[NSString stringWithFormat:@"%ld", (long)[number integerValue]] floatValue]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([number integerValue] * (12 + 6), 0, 12, 12)];
        imageView.image = [UIImage imageNamed:@"icon_star3"];
        [self.bottomToolBar.starsView addSubview:imageView];
    }
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 178 - (kTabBarHeight - 49))];
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
    }
    return _webView;
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
