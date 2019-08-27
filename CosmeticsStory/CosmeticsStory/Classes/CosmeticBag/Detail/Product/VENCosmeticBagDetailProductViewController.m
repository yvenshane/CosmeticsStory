//
//  VENCosmeticBagDetailProductViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/25.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENCosmeticBagDetailProductViewController.h"
#import "VENHomePageSearchResultsTableViewCell.h"
#import "VENProductDetailViewController.h"
#import "VENHomePageSearchResultsModel.h"

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENCosmeticBagDetailProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    self.tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageSearchResultsTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - self.headerViewHeight - 44 - kStatusBarAndNavigationBarHeight);
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageSearchResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.goodsListArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageSearchResultsModel *model = self.goodsListArr[indexPath.row];
    // push
    VENProductDetailViewController *vc = [[VENProductDetailViewController alloc] init];
    vc.goods_id = model.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 121;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end

