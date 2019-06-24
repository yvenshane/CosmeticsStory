//
//  VENMessageViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/13.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMessageViewController.h"
#import "VENMessageTableViewCell.h"
#import "VENMessageModel.h"
#import "VENBaseWebViewController.h"

@interface VENMessageViewController ()
@property (nonatomic, copy) NSArray *contentArr;
@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的消息";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMessageTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
    
    [self loadDataSource];
}

- (void)loadDataSource {
    [[VENApiManager sharedManager] myMessageListPageWithSuccessBlock:^(id  _Nonnull responseObject) {
        self.contentArr = responseObject[@"content"];
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENMessageModel *model = self.contentArr[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.dateLabel.text = model.addtime;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMessageModel *model = self.contentArr[indexPath.row];
    
    [[VENApiManager sharedManager] myMessageDetailPageWithParameters:@{@"id" : model.id} successBlock:^(id  _Nonnull responseObject) {
        
        VENBaseWebViewController *vc = [[VENBaseWebViewController alloc] init];
        vc.navigationItemTitle = @"";
        
        NSString *title = [NSString stringWithFormat:@"<font size=4>%@</font>", responseObject[@"content"][@"title"]];
        NSString *date = [NSString stringWithFormat:@"<font size=2 color=#999999>%@</font>", responseObject[@"content"][@"addtime"]];
        
        vc.HTMLString = [NSString stringWithFormat:@"%@<br><br>%@<br><br>%@", title, date, responseObject[@"content"][@"content"]];
        
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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
