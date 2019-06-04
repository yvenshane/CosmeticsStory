//
//  VENListPickerView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENListPickerView.h"
#import "VENListPickerViewCell.h"
#import "VENDataPageModel.h"

@interface VENListPickerView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VENDataPageModel *model;

@end

static const NSInteger kRowMaxCount = 5;
static const CGFloat kToolBarHeight = 48;
static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENListPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerNib:[UINib nibWithNibName:@"VENListPickerViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.pickerView addSubview:tableView];
        
        _tableView = tableView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = self.dataSourceArr.count > kRowMaxCount ? kRowMaxCount * 58 : self.dataSourceArr.count * 58;
    self.viewHeight = height;
    self.tableView.frame = CGRectMake(0, kToolBarHeight, kMainScreenWidth, height);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENListPickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENDataPageModel *model = self.dataSourceArr[indexPath.row];
    cell.titleLabel.text = model.name;
    cell.titleLabel.textColor = model.selected ? COLOR_THEME : UIColorFromRGB(0x333333);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (VENDataPageModel *model in self.dataSourceArr) {
        model.selected = NO;
    }
    
    VENDataPageModel *model = self.dataSourceArr[indexPath.row];
    model.selected = YES;
    [tableView reloadData];
    
    self.model = model;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58.0f;
}

- (void)confirmButtonClick {
    self.listPickerViewBlock(self.model);
    
    [self hidden];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
