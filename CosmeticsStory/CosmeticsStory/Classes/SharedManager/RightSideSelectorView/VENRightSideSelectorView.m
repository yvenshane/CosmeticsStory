//
//  VENRightSideSelectorView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/7/23.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENRightSideSelectorView.h"

@interface VENRightSideSelectorView () <UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, copy) NSArray *label_comprehensiveArr;
@property (nonatomic, copy) NSArray *label_purposeArr;
@property (nonatomic, copy) NSArray *label_effectArr;
@property (nonatomic, copy) NSArray *label_priceArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENRightSideSelectorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *closeButton = [[UIButton alloc] init];
        closeButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
        [self addSubview:closeButton];
        
        UIButton *resetButton = [[UIButton alloc] init];
        resetButton.backgroundColor = UIColorFromRGB(0xFFBF47);
        [resetButton setTitle:@"重置" forState:UIControlStateNormal];
        [resetButton addTarget:self action:@selector(resetButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:resetButton];
        
        UIButton *confirmButton = [[UIButton alloc] init];
        confirmButton.backgroundColor = UIColorFromRGB(0xFF9400);
        [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmButton];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
        
        _closeButton = closeButton;
        _resetButton = resetButton;
        _confirmButton = confirmButton;
        _tableView = tableView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat selfWidth = 315.0f;
    
    self.closeButton.frame = CGRectMake(0, 0, kMainScreenWidth - selfWidth, kMainScreenHeight);
    self.resetButton.frame = CGRectMake(kMainScreenWidth - selfWidth, kMainScreenHeight - 48, 100, 48);
    self.confirmButton.frame = CGRectMake(kMainScreenWidth - selfWidth + 100, kMainScreenHeight - 48, 215, 48);
    self.tableView.frame = CGRectMake(kMainScreenWidth - selfWidth, 0, selfWidth, kMainScreenHeight - 48);
}

- (void)setDataSource:(NSDictionary *)dataSource {
    _dataSource = dataSource;
    
    self.label_comprehensiveArr = dataSource[@"label_comprehensiveArr"];
    self.label_purposeArr = dataSource[@"label_purposeArr"];
    self.label_effectArr = dataSource[@"label_effectArr"];
    self.label_priceArr = dataSource[@"label_priceArr"];
    
    [self.tableView reloadData];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    
    CGFloat selfWidth = 315.0f;
    CGFloat y = kStatusBarHeight;
    y += 11;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(19, y, selfWidth, 20)];
    label.text = @"综合"; // 用途 功效 价格
    label.textColor = UIColorFromRGB(0x666666);
    label.font = [UIFont systemFontOfSize:14.0f];
    [headerView addSubview:label];
    
    y += 20 + 10;
    
    CGFloat width = (selfWidth - 19 * 2 - 9) / 2;
    for (NSInteger i = 0; i < self.label_comprehensiveArr.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(19 + i * 9 + i * width, y, width, 40)];
        [button setTitle:self.label_comprehensiveArr[i][@"name"] forState:UIControlStateNormal];
        
        if ([button.titleLabel.text isEqualToString:self.comprehensive]) {
            button.selected = YES;
        }
        
        button.backgroundColor = button.selected ? UIColorFromRGB(0xFEF2E1) : UIColorFromRGB(0xF3F3F3);
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xFF9400) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button addTarget:self action:@selector(comprehensiveClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        ViewRadius(button, 20);
        
        if (button.selected) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 23, 40 - 16, 23, 16)];
            imageView.image = [UIImage imageNamed:@""];// icon_selected
            [button addSubview:imageView];
        }
    }
    
    y += 40 + 32;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(19, y, selfWidth, 20)];
    label2.text = @"用途";
    label2.textColor = UIColorFromRGB(0x666666);
    label2.font = [UIFont systemFontOfSize:14.0f];
    [headerView addSubview:label2];
    
    y += 20 + 10;
    
    CGFloat width2 = (selfWidth - 19 * 2 - 8) / 3;
    CGFloat x = 0;
    for (NSInteger i = 0; i < self.label_purposeArr.count; i++) {
        
        x = 19 + i % 3 * 8 + i % 3 * width2;
        
        if (i % 3 == 0) {
            if (i != 0) {
                y += 40 + 10;
            }
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width2, 40)];
        [button setTitle:self.label_purposeArr[i][@"name"] forState:UIControlStateNormal];
        
        if ([button.titleLabel.text isEqualToString:self.purpose]) {
            button.selected = YES;
        }
        
        button.backgroundColor = button.selected ? UIColorFromRGB(0xFEF2E1) : UIColorFromRGB(0xF3F3F3);
        [button setTitle:self.label_purposeArr[i][@"name"] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xFF9400) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button addTarget:self action:@selector(purposeClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        ViewRadius(button, 20);
        
        if (button.selected) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width2 - 23, 40 - 16, 23, 16)];
            imageView.image = [UIImage imageNamed:@""];// icon_selected
            [button addSubview:imageView];
        }
    }
    
    y += 40 + 32;
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(19, y, selfWidth, 20)];
    label3.text = @"功效";
    label3.textColor = UIColorFromRGB(0x666666);
    label3.font = [UIFont systemFontOfSize:14.0f];
    [headerView addSubview:label3];
    
    y += 20 + 10;
    
    CGFloat x2 = 0;
    for (NSInteger i = 0; i < self.label_effectArr.count; i++) {
        
        x2 = 19 + i % 3 * 8 + i % 3 * width2;
        
        if (i % 3 == 0) {
            if (i != 0) {
                y += 40 + 10;
            }
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x2, y, width2, 40)];
        [button setTitle:self.label_effectArr[i][@"name"] forState:UIControlStateNormal];
        
        if ([button.titleLabel.text isEqualToString:self.effect]) {
            button.selected = YES;
        }
        
        button.backgroundColor = button.selected ? UIColorFromRGB(0xFEF2E1) : UIColorFromRGB(0xF3F3F3);
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xFF9400) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button addTarget:self action:@selector(effectClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        ViewRadius(button, 20);
        
        if (button.selected) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width2 - 23, 40 - 16, 23, 16)];
            imageView.image = [UIImage imageNamed:@""];// icon_selected
            [button addSubview:imageView];
        }
    }
    
    y += 40 + 32;
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(19, y, selfWidth, 20)];
    label4.text = @"价格";
    label4.textColor = UIColorFromRGB(0x666666);
    label4.font = [UIFont systemFontOfSize:14.0f];
    [headerView addSubview:label4];
    
    y += 20 + 10;
    
    CGFloat x3 = 0;
    for (NSInteger i = 0; i < self.label_priceArr.count; i++) {
        
        x3 = 19 + i % 3 * 8 + i % 3 * width2;
        
        if (i % 3 == 0) {
            if (i != 0) {
                y += 40 + 10;
            }
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x3, y, width2, 40)];
        [button setTitle:self.label_priceArr[i][@"name"] forState:UIControlStateNormal];
        
        if ([button.titleLabel.text isEqualToString:self.price]) {
            button.selected = YES;
        }
        
        button.backgroundColor = button.selected ? UIColorFromRGB(0xFEF2E1) : UIColorFromRGB(0xF3F3F3);
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xFF9400) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button addTarget:self action:@selector(priceClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        ViewRadius(button, 20);
        
        if (button.selected) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width2 - 23, 40 - 16, 23, 16)];
            imageView.image = [UIImage imageNamed:@""];// icon_selected
            [button addSubview:imageView];
        }
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kStatusBarHeight + 11 + (20 + 10) * 4 + 32 * 4 + ceilf(self.label_comprehensiveArr.count / 2.0) * (40 + 10) + ceilf(self.label_purposeArr.count / 3.0) * (40 + 10) + ceilf(self.label_effectArr.count / 3.0) * (40 + 10) + ceilf(self.label_priceArr.count / 3.0) * (40 + 10) - 40;
}

#pragma mark - 重置 / 确认
- (void)resetButtonClick {
    self.comprehensive = self.label_comprehensiveArr.firstObject[@"name"];
    self.purpose = @"";
    self.effect = @"";
    self.price = @"";
    
    [self.tableView reloadData];
}

- (void)confirmButtonClick {
    self.rightSideSelectorViewBlock(@[self.comprehensive, self.purpose, self.effect, self.price]);
}

#pragma mark - buttonClick
- (void)comprehensiveClick:(UIButton *)button {
    self.comprehensive = button.titleLabel.text;
    [self.tableView reloadData];
}

- (void)purposeClick:(UIButton *)button {
    self.purpose = button.titleLabel.text;
    [self.tableView reloadData];
}

- (void)effectClick:(UIButton *)button {
    self.effect = button.titleLabel.text;
    [self.tableView reloadData];
}

- (void)priceClick:(UIButton *)button {
    self.price = button.titleLabel.text;
    [self.tableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
