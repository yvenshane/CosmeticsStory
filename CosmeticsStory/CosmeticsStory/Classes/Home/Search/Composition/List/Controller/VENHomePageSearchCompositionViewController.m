//
//  VENHomePageSearchCompositionViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/22.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSearchCompositionViewController.h"
#import "VENHomePageSearchCompositionTableViewCell.h"
#import "VENHomePageSearchCompositionDetailsPageViewController.h"
#import "VENHomePageSearchCompositionModel.h"

@interface VENHomePageSearchCompositionViewController ()
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *contentMuArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENHomePageSearchCompositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 44);
    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageSearchCompositionTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataSourceWithPage:@"1"];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataSourceWithPage:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"LOAD_DATASOURCE" object:nil];
}

- (void)notificationCenter:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    self.keyword = dict[@"keyword"];
    
    [self loadDataSourceWithPage:@"1"];
}

- (void)loadDataSourceWithPage:(NSString *)page {
    
    NSDictionary *parameters = @{@"start" : page,
                                 @"size" : @"10",
                                 @"name" : [VENEmptyClass isEmptyString:self.keyword] ? @"" : self.keyword};
    
    [[VENApiManager sharedManager] searchPageCompositionListWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
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
    VENHomePageSearchCompositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.contentMuArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        
         VENHomePageSearchCompositionModel *model = self.contentMuArr[indexPath.row];
        
        VENHomePageSearchCompositionDetailsPageViewController *vc = [[VENHomePageSearchCompositionDetailsPageViewController alloc] init];
        vc.ingredients_id = model.ingredients_id;
        vc.isPresent = YES;
        VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    });
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
