//
//  VENHomePageFindViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/5.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageFindViewController.h"
#import "VENWaterfallFlowViewCollectionViewCell.h"
#import "XRWaterfallLayout.h"
#import "VENHomePageModel.h"
#import "VENHomePageFindDetailViewController.h"

@interface VENHomePageFindViewController () <UICollectionViewDataSource, UICollectionViewDelegate, XRWaterfallLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionVieww;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *contentMuArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENHomePageFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"发现";
    
    [self setupCollectionView];
    
    [self loadDataSourceWithPage:@"1"];
}

- (void)loadDataSourceWithPage:(NSString *)page {
    
    NSDictionary *parameters = @{@"start" : page, @"size" : @"10"};
    [[VENApiManager sharedManager] goodsNewsListWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
       
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
        imageWidth = width;
        imageHeight = imageHeight * (imageWidth / width );
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
        imageWidth = width;
        imageHeight = imageHeight * (imageWidth / width );
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
    [self.view addSubview:collectionView];
    
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataSourceWithPage:@"1"];
    }];
    
    collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataSourceWithPage:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    _collectionVieww = collectionView;
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
