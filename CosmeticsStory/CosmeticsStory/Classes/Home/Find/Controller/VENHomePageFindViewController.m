//
//  VENHomePageFindViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/5.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageFindViewController.h"
#import "VENWaterfallFlowView.h"

@interface VENHomePageFindViewController ()
@property (nonatomic, strong) VENWaterfallFlowView *waterfallFlowView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *contentMuArr;

@end

@implementation VENHomePageFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"发现";
    
    
    VENWaterfallFlowView *waterfallFlowView = [[VENWaterfallFlowView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight)];
    [self.view addSubview:waterfallFlowView];
    
    waterfallFlowView.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataSourceWithPage:@"1"];
    }];
    
    waterfallFlowView.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataSourceWithPage:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    _waterfallFlowView = waterfallFlowView;
    
    [self loadDataSourceWithPage:@"1"];
}

- (void)loadDataSourceWithPage:(NSString *)page {
    
    NSDictionary *parameters = @{@"start" : page, @"size" : @"10"};
    [[VENApiManager sharedManager] goodsNewsListWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
       
        if ([page integerValue] == 1) {
            [self.waterfallFlowView.collectionView.mj_header endRefreshing];
            
            self.contentMuArr = [NSMutableArray arrayWithArray:responseObject];
            
            self.page = 1;
        } else {
            [self.waterfallFlowView.collectionView.mj_footer endRefreshing];
            
            [self.contentMuArr addObjectsFromArray:responseObject];
        }
        
        self.waterfallFlowView.goodsNewsListArr = self.contentMuArr;
        [self.waterfallFlowView.collectionView reloadData];
        
    }];
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
