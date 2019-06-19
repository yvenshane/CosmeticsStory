//
//  VENHomePageSearchCompositionDetailsPageViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/29.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSearchCompositionDetailsPageViewController.h"
#import "VENHomePageSearchCompositionDetailsPageTableHeaderView.h"
#import "VENCommentTableViewCell.h"
#import "VENHomePageSearchCompositionDetailsPageModel.h"
#import "VENHomePageSearchCompositionDetailsPageReleaseCommentViewController.h"
#import "VENHomePageSearchCompositionDetailsPageCommentModel.h"
#import "VENHomePageSearchCompositionDetailCommentDetailPageViewController.h"

@interface VENHomePageSearchCompositionDetailsPageViewController ()
@property (nonatomic, strong) VENHomePageSearchCompositionDetailsPageModel *model;
@property (nonatomic, strong) NSMutableArray *commentMuArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENHomePageSearchCompositionDetailsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationItemLeftBarButtonItem];
    self.isPresent = YES;
    self.navigationItem.title = @"成分详情";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VENCommentTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 48  - (kTabBarHeight - 49));
    [self.view addSubview:self.tableView];
    
    [self setupBottomToolBar];
    
    [self loadDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCommentData) name:@"Refresh_Composition_Detail_Page" object:nil];
}

- (void)loadDataSource {
    [[VENApiManager sharedManager] searchPageCompositionDetailWithParameters:@{@"ingredients_id" : self.ingredients_id} successBlock:^(id  _Nonnull responseObject) {
        
        self.model = responseObject[@"content"];
        
        [self loadCommentData];
    }];
}

- (void)loadCommentData {
    [[VENApiManager sharedManager] searchPageCompositionDetailCommentListWithParameters:@{@"ingredients_id" : self.ingredients_id} successBlock:^(id  _Nonnull responseObject) {
        
        self.commentMuArr = responseObject[@"content"];
        
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.commentMuArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VENHomePageSearchCompositionDetailsPageCommentModel *model = self.commentMuArr[indexPath.row];
    
    VENHomePageSearchCompositionDetailCommentDetailPageViewController *vc = [[VENHomePageSearchCompositionDetailCommentDetailPageViewController alloc] init];
    vc.id = model.id;
    vc.name = self.model.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VENHomePageSearchCompositionDetailsPageTableHeaderView *headerView = [[UINib nibWithNibName:@"VENHomePageSearchCompositionDetailsPageTableHeaderView" bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
    headerView.model = self.model;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 500;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - BottomToolBar
- (void)setupBottomToolBar {
    UIView *bottomToolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 48 - (kTabBarHeight - 49), kMainScreenWidth, 48)];
    bottomToolBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomToolBarView];
    
    CGFloat width = kMainScreenWidth / 3;
    UIButton *likeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 48)];
    [likeButton setTitle:@"  收藏" forState:UIControlStateNormal];
    [likeButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [likeButton setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
    likeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBarView addSubview:likeButton];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(width, 0, width, 48)];
    [addButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBarView addSubview:addButton];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(width * 2, 0, width, 48)];
    [shareButton setTitle:@"  分享" forState:UIControlStateNormal];
    [shareButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBarView addSubview:shareButton];
}

- (void)likeButtonClick:(UIButton *)button {
    
    NSLog(@"收藏");
    
//    UIView *backgroundView = [[UIView alloc] init];
//    backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
//    [[UIApplication sharedApplication].keyWindow addSubview:backgroundView];
}

- (void)addButtonClick:(UIButton *)button {
    VENHomePageSearchCompositionDetailsPageReleaseCommentViewController *vc = [[VENHomePageSearchCompositionDetailsPageReleaseCommentViewController alloc] init];
    vc.titleText = self.model.name;
    vc.ingredients_id = self.ingredients_id;
    VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)shareButtonClick:(UIButton *)button {
    
    
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
