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
#import "VENCommentDetailPageViewController.h"
#import "VENCosmeticBagPopupView.h"
#import "VENCosmeticBagPopupViewTwo.h"
#import <UShareUI/UShareUI.h>

@interface VENHomePageSearchCompositionDetailsPageViewController ()
@property (nonatomic, strong) VENHomePageSearchCompositionDetailsPageModel *model;
@property (nonatomic, strong) NSMutableArray *commentMuArr;
@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) VENCosmeticBagPopupViewTwo *popupViewTwo;

@property (nonatomic, assign) BOOL isShow;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENHomePageSearchCompositionDetailsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationItemLeftBarButtonItem];
    self.navigationItem.title = @"成分详情";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VENCommentTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 48  - (kTabBarHeight - 49));
    [self.view addSubview:self.tableView];
    
    [self setupBottomToolBar];
    
    [self loadDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCommentData:) name:@"Refresh_Composition_Detail_Page" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePopupView) name:@"Remove_PopupView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPopupView) name:@"Add_PopupView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
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
    [[VENApiManager sharedManager] searchPageCompositionDetailWithParameters:@{@"ingredients_id" : self.ingredients_id} successBlock:^(id  _Nonnull responseObject) {
        
        self.model = responseObject[@"content"];
        
        if ([self.model.userCollection integerValue] == 1) {
            [self.likeButton setImage:[UIImage imageNamed:@"icon_clo_sel"] forState:UIControlStateNormal];
        } else {
            [self.likeButton setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
        }
        
        [self loadCommentData:nil];
    }];
}

- (void)loadCommentData:(NSNotification *)noti {
    [[VENApiManager sharedManager] searchPageCompositionDetailCommentListWithParameters:@{@"ingredients_id" : self.ingredients_id} successBlock:^(id  _Nonnull responseObject) {
        
        self.commentMuArr = [NSMutableArray arrayWithArray:responseObject[@"content"]];
        
        if ([noti.userInfo[@"type"] isEqualToString:@"release"]) {
            self.model.commentNumber = [NSString stringWithFormat:@"%ld", [self.model.commentNumber integerValue] + 1];
        }
        
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.goodButton.tag = indexPath.row;
    [cell.goodButton addTarget:self action:@selector(goodButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.model = self.commentMuArr[indexPath.row];
    
    return cell;
}

#pragma mark - 点赞
- (void)goodButtonClick:(UIButton *)button {
    
    VENHomePageSearchCompositionDetailsPageCommentModel *model = self.commentMuArr[button.tag];
    
    NSDictionary *parameters = @{@"cid" : model.id,
                                 @"type" : @"2"};
    [[VENApiManager sharedManager] praiseCommentWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
        
        if (button.selected) {
            model.userPraise = @"0";
            model.praiseCount = [NSString stringWithFormat:@"%ld", [model.praiseCount integerValue] - 1];
        } else {
            model.userPraise = @"1";
            model.praiseCount = [NSString stringWithFormat:@"%ld", [model.praiseCount integerValue] + 1];
        }
        
        [self.tableView reloadData];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VENHomePageSearchCompositionDetailsPageCommentModel *model = self.commentMuArr[indexPath.row];
    
    VENCommentDetailPageViewController *vc = [[VENCommentDetailPageViewController alloc] init];
    vc.id = model.id;
    vc.name = self.model.name;
    vc.type = @"composition";
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VENHomePageSearchCompositionDetailsPageTableHeaderView *headerView = [[UINib nibWithNibName:@"VENHomePageSearchCompositionDetailsPageTableHeaderView" bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
    
    headerView.moreButton.selected = self.isShow;
    headerView.model = self.model;
    
    [headerView.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return headerView;
}

- (void)moreButtonClick:(UIButton *)button {
    self.isShow = YES;
    [self.tableView reloadData];
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
        NSDictionary *parameters = @{@"gid" : self.ingredients_id,
                                     @"type" : @"2"};
        
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
    popupView.ingredients_id = self.ingredients_id;
    popupView.isProduct = NO;
    
    [backgroundButton addSubview:popupView];
}

- (void)closeButtonClick {
    [self.backgroundButton removeFromSuperview];
}

- (void)addButtonClick:(UIButton *)button {
    VENHomePageSearchCompositionDetailsPageReleaseCommentViewController *vc = [[VENHomePageSearchCompositionDetailsPageReleaseCommentViewController alloc] init];
    vc.titleText = self.model.name;
    vc.ingredients_id = self.ingredients_id;
    VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)shareButtonClick:(UIButton *)button {
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
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Sina)]];
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
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
