//
//  VENFootprintCommentProductPageViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/25.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENFootprintCommentProductPageViewController.h"
#import "VENFootprintCommentTableViewCell.h"
#import "VENFootprintCommentModel.h"
#import "VENProductDetailViewController.h"

@interface VENFootprintCommentProductPageViewController ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *contentMuArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENFootprintCommentProductPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"VENFootprintCommentTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 44);
    
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
    NSDictionary *parameters = @{@"start" : page,
                                 @"size" : @"10"};
    
    [[VENApiManager sharedManager] myFootprintCommentProductPageWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
        
        if ([page integerValue] == 1) {
            [self.tableView.mj_header endRefreshing];
            
            self.contentMuArr = [NSMutableArray arrayWithArray:responseObject[@"content"]];
            
            self.page = 1;
        } else {
            [self.tableView.mj_footer endRefreshing];
            
            [self.contentMuArr addObjectsFromArray:responseObject[@"content"]];
        }
        
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENFootprintCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isProduct = YES;
    cell.model = self.contentMuArr[indexPath.row];
    
    cell.goodsButton.tag = indexPath.row;
    [cell.goodsButton addTarget:self action:@selector(goodsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)goodsButtonClick:(UIButton *)button {
    
    VENFootprintCommentModel *model = self.contentMuArr[button.tag];
// push
    VENProductDetailViewController *vc = [[VENProductDetailViewController alloc] init];
    vc.goods_id = model.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 255;
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
