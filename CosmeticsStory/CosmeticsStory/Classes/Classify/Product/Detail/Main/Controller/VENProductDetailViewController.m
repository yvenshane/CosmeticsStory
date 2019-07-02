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
#import "VENProductDetailJiuCuoViewController.h"
#import "VENCosmeticBagPopupView.h"
#import "VENCosmeticBagPopupViewTwo.h"
#import "VENProductDetailPageAllCompositionViewController.h"
#import <UShareUI/UShareUI.h>

@interface VENProductDetailViewController ()
@property (nonatomic, strong) VENProductDetailModel *model;
@property (nonatomic, strong) NSMutableArray *commentMuArr;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) VENCosmeticBagPopupViewTwo *popupViewTwo;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePopupView) name:@"Remove_PopupView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPopupView) name:@"Add_PopupView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    if (self.isPresents) {
        self.isPresent = YES;
        [self setupNavigationItemLeftBarButtonItem];
        
        self.tableView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 48  - (kTabBarHeight - 49));
    }
    
    self.type = 1;
    
    [self setupBottomToolBar];
    [self setupNavigationItemRightBarButtonItem];
    
    [self loadDataSource];
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    NSDictionary *userInfoDict = notification.userInfo;
    CGRect keyboardFrame = [[userInfoDict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat width = 300;
    CGFloat height = 44 + 48 + 160;
    
    if (keyboardFrame.origin.y == kMainScreenHeight) {
        _popupViewTwo.frame = CGRectMake(kMainScreenWidth / 2 - width / 2, kMainScreenHeight / 2 - height / 2, width, height);
    } else {
        _popupViewTwo.frame = CGRectMake(kMainScreenWidth / 2 - width / 2, kMainScreenHeight / 2 - height, width, height);
    }
}

- (void)addPopupView {
    [self.backgroundButton removeFromSuperview];
    
    UIButton *backgroundButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    backgroundButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    [[UIApplication sharedApplication].keyWindow addSubview:backgroundButton];
    _backgroundButton = backgroundButton;
    
    CGFloat width = 300;
    CGFloat height = 44 + 48 + 160;
    VENCosmeticBagPopupViewTwo *popupView = [[VENCosmeticBagPopupViewTwo alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - width / 2, kMainScreenHeight / 2 - height / 2, width, height)];
    popupView.cosmeticBagPopupViewTwoBlock = ^(NSString *str) {
        [self.backgroundButton removeFromSuperview];
        [[VENApiManager sharedManager] detailPageCosmeticBagListWithSuccessBlock:^(id  _Nonnull responseObject) {
            [self setupPopupViewWithDataSource:[NSMutableArray arrayWithArray:responseObject[@"content"]]];
        }];
    };
    [popupView.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundButton addSubview:popupView];
    
    _popupViewTwo = popupView;
}

- (void)removePopupView {
    [self.backgroundButton removeFromSuperview];
    self.model.userCollection = @"1";
    [self.likeButton setImage:[UIImage imageNamed:@"icon_clo_sel"] forState:UIControlStateNormal];
}

- (void)loadDataSource {
    [[VENApiManager sharedManager] searchPageProductDetailWithParameters:@{@"goods_id" : self.goods_id} successBlock:^(id  _Nonnull responseObject) {
        
        self.model = responseObject[@"content"];
        
        if ([self.model.userCollection integerValue] == 1) {
            [self.likeButton setImage:[UIImage imageNamed:@"icon_clo_sel"] forState:UIControlStateNormal];
        } else {
            [self.likeButton setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
        }
        
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
        
        if ([VENEmptyClass isEmptyString:self.model.url]) {
            headerView.urlImageView.hidden = YES;
            headerView.buttonLayoutConstraintTop.constant = 359 - 189;
        } else {
            headerView.urlImageView.hidden = NO;
            headerView.buttonLayoutConstraintTop.constant = 359;
        }
        
        headerView.model = self.model;
        headerView.type = self.type;
        
        headerView.headerViewBlock = ^(NSInteger tag) {
            self.type = tag;
            [self.tableView reloadData];
        };
        
        [headerView.urlButton addTarget:self action:@selector(urlButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        return headerView;
    } else {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor clearColor];
        return headerView;
    }
}

#pragma maek - urlbutton click
- (void)urlButtonClick {
    if (![VENEmptyClass isEmptyString:self.model.url]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.url]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        if ([VENEmptyClass isEmptyString:self.model.url]) {
            return 410 - 189;
        }
        
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
    
    if (self.isPresents) {
        bottomToolBarView.frame = CGRectMake(0, kMainScreenHeight - 48 - (kTabBarHeight - 49), kMainScreenWidth, 48);
    }
    
    CGFloat width = kMainScreenWidth / 3;
    UIButton *likeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 48)];
    [likeButton setTitle:@"  收藏" forState:UIControlStateNormal];
    [likeButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [likeButton setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
    likeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBarView addSubview:likeButton];
    _likeButton = likeButton;
    
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
    if ([self.model.userCollection integerValue] == 1) {
        NSDictionary *parameters = @{@"gid" : self.goods_id,
                                     @"type" : @"1"};
        
        [[VENApiManager sharedManager] detailPageCosmeticBagCollectionWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
            
            self.model.userCollection = @"0";
            [self.likeButton setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
        }];
    } else {
        [[VENApiManager sharedManager] detailPageCosmeticBagListWithSuccessBlock:^(id  _Nonnull responseObject) {
            [self setupPopupViewWithDataSource:[NSMutableArray arrayWithArray:responseObject[@"content"]]];
        }];
    }
}

- (void)setupPopupViewWithDataSource:(NSMutableArray *)dataSource {
    UIButton *backgroundButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    backgroundButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    [[UIApplication sharedApplication].keyWindow addSubview:backgroundButton];
    _backgroundButton = backgroundButton;
    
    CGFloat tableViewHeight = 75 * (dataSource.count > 4 ? 4 : dataSource.count);
    CGFloat width = 300;
    CGFloat height = 44 + 48 + tableViewHeight;
    
    VENCosmeticBagPopupView *popupView = [[VENCosmeticBagPopupView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - width / 2, kMainScreenHeight / 2 - height / 2, width, height)];
    [popupView.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    popupView.contentMuArr = dataSource;
    popupView.ingredients_id = self.goods_id;
    popupView.isProduct = YES;
    
    [backgroundButton addSubview:popupView];
}

- (void)closeButtonClick {
    [self.backgroundButton removeFromSuperview];
}



- (void)addButtonClick:(UIButton *)button {
    VENProductDetailsPageReleaseCommentViewController *vc = [[VENProductDetailsPageReleaseCommentViewController alloc] init];
    vc.titleText = self.model.goods_name_ch;
    vc.goods_id = self.goods_id;
    VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)shareButtonClick:(UIButton *)button {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Sina)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    
    NSString *title = self.model.share[@"title"];
    NSString *descriptionn = self.model.share[@"descriptionn"];
    NSString *img = self.model.share[@"img"];
    NSString *url = self.model.share[@"url"];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descriptionn thumImage:img];
    //设置网页地址
    shareObject.webpageUrl = url;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
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
    if (![VENEmptyClass isEmptyArray:self.model.ingredientContent]) {
        VENProductDetailPageAllCompositionViewController *vc = [[VENProductDetailPageAllCompositionViewController alloc] init];
        vc.goods_id = self.goods_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)cellThreeMoreInformationButtonClick {
    VENProductDetailBrandStoryViewController *vc = [[VENProductDetailBrandStoryViewController alloc] init];
    vc.goods_brand = self.model.goods_brand;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - navigation right button
- (void)setupNavigationItemRightBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setImage:[UIImage imageNamed:@"icon_jiucuo"] forState:UIControlStateNormal];
    [button setTitle:@"  纠错" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button addTarget:self action:@selector(jiucuoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)jiucuoButtonClick {
    VENProductDetailJiuCuoViewController *vc = [[VENProductDetailJiuCuoViewController alloc] init];
    vc.cnName = self.model.goods_name_ch;
    vc.enName = self.model.goods_name_en;
    vc.ingredients_id = self.model.goods_id;
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
