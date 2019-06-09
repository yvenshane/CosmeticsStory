//
//  VENHomePageCouponViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/5.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageCouponViewController.h"
#import "VENHomePageCouponTableViewCell.h"
#import "VENHomePageCouponModel.h"

@interface VENHomePageCouponViewController ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *contentMuArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENHomePageCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"优惠券";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageCouponTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataSourceWithPage:@"1"];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataSourceWithPage:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    [self.view addSubview:self.tableView];
    
    [self loadDataSourceWithPage:@"1"];
}

- (void)loadDataSourceWithPage:(NSString *)page {
    NSDictionary *parameters = @{@"start" : page, @"size" : @"10"};
    [[VENApiManager sharedManager] couponListWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
        
        if ([page integerValue] == 1) {
            [self.tableView.mj_header endRefreshing];
          
            self.contentMuArr = [NSMutableArray arrayWithArray:responseObject];
            
            self.page = 1;
        } else {
            [self.tableView.mj_footer endRefreshing];
            
            [self.contentMuArr addObjectsFromArray:responseObject];
        }

        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENHomePageCouponModel *model = self.contentMuArr[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    cell.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.titleLabel.text = model.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageCouponModel *model = self.contentMuArr[indexPath.row];
    
    NSLog(@"%@", model.id);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 190;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
