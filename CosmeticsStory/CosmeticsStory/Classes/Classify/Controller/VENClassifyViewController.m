//
//  VENClassifyViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/7.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENClassifyViewController.h"
#import "VENClassifyCollectionViewCell.h"
#import "VENClassifyCollectionViewCell2.h"
#import "VENClassifyCollectionReusableView.h"
#import "VENClassifyPageModel.h"

@interface VENClassifyViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIImageView *backgroundVieww;
@property (nonatomic, strong) UICollectionView *collectionVieww;
@property (nonatomic, strong) UICollectionView *collectionVieww2;
@property (nonatomic, copy) NSString *titleLabelText;

@property (nonatomic, copy) NSArray *catArr;
@property (nonatomic, copy) NSArray *contentArr;


@end

static NSString *const cellIdentifier = @"cellIdentifier";
static NSString *const cellIdentifier2 = @"cellIdentifier2";
static NSString *const cellIdentifier3 = @"cellIdentifier3";
@implementation VENClassifyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    [self setupHeaderView];
    [self setupContentView];
    
    [self loadDataSource];
}

- (void)loadDataSource {
    [[VENApiManager sharedManager] classifyPageWithSuccessBlock:^(id  _Nonnull responseObject) {
        self.catArr = responseObject[@"cat"];
        
        [self.backgroundVieww sd_setImageWithURL:[NSURL URLWithString:responseObject[@"image"]]];
        [self.collectionVieww reloadData];
        
        VENClassifyPageModel *model = self.catArr[0];
        [[VENApiManager sharedManager] classifyPageWithParameters:@{@"cat_id" : model.cat_id} successBlock:^(id  _Nonnull responseObject) {
            
            self.contentArr = responseObject[@"content"];
            self.titleLabelText = model.cat_name;
            
           [self.collectionVieww2 reloadData];
        }];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return collectionView.tag == 998 ? self.catArr.count : self.contentArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 998) {
        VENClassifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        VENClassifyPageModel *model = self.catArr[indexPath.row];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.cat_image]];
        cell.titleLabel.text = model.cat_name;
        
        return cell;
    } else {
        VENClassifyCollectionViewCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier2 forIndexPath:indexPath];
        VENClassifyPageModel *model = self.contentArr[indexPath.row];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.cat_image]];
        cell.titleLabel.text = model.cat_name;
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 998) {
        VENClassifyPageModel *model = self.catArr[indexPath.row];
        
        if (![self.titleLabelText isEqualToString:model.cat_name]) {
            [[VENApiManager sharedManager] classifyPageWithParameters:@{@"cat_id" : model.cat_id} successBlock:^(id  _Nonnull responseObject) {
                
                self.contentArr = responseObject[@"content"];
                self.titleLabelText = model.cat_name;
                
                [self.collectionVieww2 reloadData];
            }];
        }
        
    } else {
        VENClassifyPageModel *model = self.contentArr[indexPath.row];
        
        NSLog(@"%@", model.cat_name);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag == 999) {
        VENClassifyCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier3 forIndexPath:indexPath];
        
        headerView.titleLabel.text = self.titleLabelText;
        
        return headerView;
    }
    return nil;
}

- (void)setupContentView {
    CGFloat width = (kMainScreenWidth - 20 - 5 * 15) / 4;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(width, 92);
    flowLayout.minimumLineSpacing = 15.0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    flowLayout.headerReferenceSize = CGSizeMake(kMainScreenWidth, 37);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 190, kMainScreenWidth - 20, kMainScreenHeight - 190 - kTabBarHeight - 10) collectionViewLayout:flowLayout];
    collectionView.tag = 999;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerNib:[UINib nibWithNibName:@"VENClassifyCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier3];
    [collectionView registerNib:[UINib nibWithNibName:@"VENClassifyCollectionViewCell2" bundle:nil] forCellWithReuseIdentifier:cellIdentifier2];
    collectionView.delegate = self;
    collectionView.dataSource = self;
//    collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    
    _collectionVieww2 = collectionView;
}

- (void)setupHeaderView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 140)];
    [self.view addSubview:imageView];
    
    CGFloat width = (kMainScreenWidth - 40 - 24) / 4.5;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(width, 75);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 25, 0, 25);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 103, kMainScreenWidth, 75) collectionViewLayout:flowLayout];
    collectionView.tag = 998;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerNib:[UINib nibWithNibName:@"VENClassifyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    
    _backgroundVieww = imageView;
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
