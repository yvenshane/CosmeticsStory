//
//  VENHomePageSearchProductViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/22.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSearchProductViewController.h"
#import "VENHomePageSearchProductHeaderFooterView.h"

@interface VENHomePageSearchProductViewController ()
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, assign) CGFloat footerViewHeight;
@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation VENHomePageSearchProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = nil;
    self.tableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([VENEmptyClass isEmptyArray:[self.userDefaults objectForKey:@"SearchResults"]]) {
        UIView *headerView = [[UIView alloc] init];
        return headerView;
    } else {
        VENHomePageSearchProductHeaderFooterView *headerView = [[VENHomePageSearchProductHeaderFooterView alloc] init];
        headerView.title = @"搜索记录";
        headerView.chipArr = [self.userDefaults objectForKey:@"SearchResults"];
        headerView.deleteButton.hidden = NO;
        headerView.headerFooterViewDeleteBlock = ^(NSString *str) {
            [self.tableView reloadData];
        };
        
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([VENEmptyClass isEmptyArray:[self.userDefaults objectForKey:@"SearchResults"]]) {
        return CGFLOAT_MIN;
    } else {
        return [self getHeightWithChipArr:[self.userDefaults objectForKey:@"SearchResults"]] + 13.5 + 10 + 17 + 13.5;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    VENHomePageSearchProductHeaderFooterView *footerView = [[VENHomePageSearchProductHeaderFooterView alloc] init];
    footerView.title = @"热门搜索";
    footerView.chipArr = @[@"123", @"132123", @"123123", @"123", @"123", @"13123", @"131223", @"123", @"131223", @"123", @"123", @"123", @"121233"];

    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self getHeightWithChipArr:@[@"123", @"132123", @"123123", @"123", @"123", @"13123", @"131223", @"123", @"131223", @"123", @"123", @"123", @"121233"]] + 13.5 + 10 + 17 + 13.5;
}

- (CGFloat)getHeightWithChipArr:(NSArray *)arr {
    
    CGFloat x = 15;
    CGFloat y = 0;
    
    for (NSInteger i = 0; i < arr.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        
        CGFloat height = 30;
        CGFloat width = [button sizeThatFits:CGSizeMake(CGFLOAT_MAX, height)].width + 30;
        
        if (x + width + 15 > kMainScreenWidth) {
            x = 15;
            y += height + 10;
        }
        
        button.frame = CGRectMake(x, y, width, height);
        x += width + 10;
    }
    
   return y + 30 + 23;
}

- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
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
