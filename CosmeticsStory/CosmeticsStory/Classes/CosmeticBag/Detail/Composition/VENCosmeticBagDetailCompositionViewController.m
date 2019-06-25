//
//  VENCosmeticBagDetailCompositionViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/25.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENCosmeticBagDetailCompositionViewController.h"
#import "VENHomePageSearchCompositionTableViewCell.h"
#import "VENHomePageSearchCompositionDetailsPageViewController.h"
#import "VENHomePageSearchCompositionModel.h"

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENCosmeticBagDetailCompositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - self.headerViewHeight - 44 - kStatusBarAndNavigationBarHeight);
    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageSearchCompositionTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ingredientsListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageSearchCompositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.ingredientsListArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageSearchCompositionModel *model = self.ingredientsListArr[indexPath.row];
    
    VENHomePageSearchCompositionDetailsPageViewController *vc = [[VENHomePageSearchCompositionDetailsPageViewController alloc] init];
    vc.ingredients_id = model.ingredients_id;
    vc.isPresent = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
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
