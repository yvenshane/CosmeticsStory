//
//  VENProductDetailViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/19.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENProductDetailViewController.h"
#import "VENProductDetailPageHeaderView.h"
#import "VENCommentTableViewCell.h"
#import "VENHomePageSearchCompositionDetailsPageCommentModel.h"
#import "VENCommentDetailPageViewController.h"
#import "VENProductDetailTableViewCellOne.h"
#import "VENProductDetailTableViewCellTwo.h"
#import "VENProductDetailTableViewCellThree.h"
#import "VENProductDetailModel.h"
#import "VENProductDetailsPageReleaseCommentViewController.h"
#import "VENProductDetailPageFooterView.h"
#import "VENBaseWebViewController.h"
#import "VENProductDetailBrandStoryViewController.h"

@interface VENProductDetailViewController ()
@property (nonatomic, strong) VENProductDetailModel *model;
@property (nonatomic, strong) NSMutableArray *commentMuArr;

@property (nonatomic, assign) NSInteger type;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
static NSString *const cellIdentifier2 = @"cellIdentifier2";
static NSString *const cellIdentifier3 = @"cellIdentifier3";
static NSString *const cellIdentifier4 = @"cellIdentifier4";
@implementation VENProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"产品详情";
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"VENCommentTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"VENProductDetailTableViewCellOne" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    [self.tableView registerNib:[UINib nibWithNibName:@"VENProductDetailTableViewCellTwo" bundle:nil] forCellReuseIdentifier:cellIdentifier3];
    [self.tableView registerNib:[UINib nibWithNibName:@"VENProductDetailTableViewCellThree" bundle:nil] forCellReuseIdentifier:cellIdentifier4];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 48  - (kTabBarHeight - 49));
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCommentData) name:@"Refresh_Product_Detail_Page" object:nil];
    
    self.type = 1;
    
    [self setupBottomToolBar];
    
    [self loadDataSource];
}

- (void)loadDataSource {
    [[VENApiManager sharedManager] searchPageProductDetailWithParameters:@{@"goods_id" : self.goods_id} successBlock:^(id  _Nonnull responseObject) {
        
        self.model = responseObject[@"content"];
        
        [self loadCommentData];
    }];
}

- (void)loadCommentData {
    [[VENApiManager sharedManager] searchPageProductDetailCommentListWithParameters:@{@"goods_id" : self.goods_id} successBlock:^(id  _Nonnull responseObject) {
        
        self.commentMuArr = responseObject[@"content"];
        
        [self.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
     return self.commentMuArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.type == 1) {
            VENProductDetailTableViewCellOne *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.contentLabel.text = self.model.descriptionn;
            [cell.moreInformationButton addTarget:self action:@selector(cellOneMoreInformationButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        } else if (self.type == 2) {
            VENProductDetailTableViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3 forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.ingredientContent = self.model.ingredientContent;
            
            [cell.moreButton addTarget:self action:@selector(cellTwoMoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.moreInformationButton addTarget:self action:@selector(cellTwoMoreInformationButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        } else {
            VENProductDetailTableViewCellThree *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier4 forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.goods_brand = self.model.goods_brand;
            
            [cell.moreInformationButton addTarget:self action:@selector(cellThreeMoreInformationButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        
    } else {
        VENCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.commentMuArr[indexPath.row];
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    } else {
        VENHomePageSearchCompositionDetailsPageCommentModel *model = self.commentMuArr[indexPath.row];
        
        VENCommentDetailPageViewController *vc = [[VENCommentDetailPageViewController alloc] init];
        vc.id = model.id;
        vc.name = self.model.goods_name_ch;
        
        vc.type = @"product";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return 250;
//    } else {
//        return 300;
//    }
    return 300;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        VENProductDetailPageHeaderView *headerView = [[UINib nibWithNibName:@"VENProductDetailPageHeaderView" bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
        headerView.model = self.model;
        headerView.type = self.type;
        
        headerView.headerViewBlock = ^(NSInteger tag) {
            self.type = tag;
            [self.tableView reloadData];
        };
        
        return headerView;
    } else {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor clearColor];
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 410;
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        VENProductDetailPageFooterView *footerView = [[UINib nibWithNibName:@"VENProductDetailPageFooterView" bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
        
        return footerView;
    } else {
        return [[UIView alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 60;
    } else {
        return CGFLOAT_MIN;
    }
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
    VENProductDetailsPageReleaseCommentViewController *vc = [[VENProductDetailsPageReleaseCommentViewController alloc] init];
    vc.titleText = self.model.goods_name_ch;
    vc.goods_id = self.goods_id;
    VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)shareButtonClick:(UIButton *)button {
    
    
}

#pragma mark - cell click
- (void)cellOneMoreInformationButtonClick {
    VENBaseWebViewController *vc = [[VENBaseWebViewController alloc] init];
    vc.HTMLString = self.model.goods_content;
    vc.isPush = YES;
    vc.navigationItem.title = @"产品功效";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cellTwoMoreButtonClick {
    UIButton *backgroundButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    backgroundButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    [backgroundButton addTarget:self action:@selector(backgroundButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:backgroundButton];
    
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - 150, kMainScreenHeight / 2 -68, 300, 136)];
    alertView.backgroundColor = [UIColor whiteColor];
    [backgroundButton addSubview:alertView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 10, 300 - 40, 136 - 10)];
    textView.text = [NSString stringWithFormat:@"备案信息备案文号：%@\n\n产地：%@\n\n生产企业（中文）：%@\n\n生产企业（英文）：%@", self.model.record_number, self.model.place_of_production, self.model.enterprise_ch, self.model.enterprise_en];
    textView.textColor = UIColorFromRGB(0x333333);
    textView.font = [UIFont systemFontOfSize:12.0f];
    textView.userInteractionEnabled = NO;
    [alertView addSubview:textView];
}

- (void)backgroundButtonClick:(UIButton *)button {
    [button removeFromSuperview];
}

- (void)cellTwoMoreInformationButtonClick {
    
}

- (void)cellThreeMoreInformationButtonClick {
    VENProductDetailBrandStoryViewController *vc = [[VENProductDetailBrandStoryViewController alloc] init];
    vc.goods_brand = self.model.goods_brand;
    [self.navigationController pushViewController:vc animated:YES];
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
