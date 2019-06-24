//
//  VENCosmeticBagPopupView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/24.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENCosmeticBagPopupView.h"
#import "VENCosmeticBagPopupViewTableViewCell.h"
#import "VENCosmeticBagModel.h"

@interface VENCosmeticBagPopupView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *lineView2;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIView *lineView3;
@property (nonatomic, strong) UIButton *determineButton;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *selectIndex;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENCosmeticBagPopupView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"收藏到护肤方案";
        titleLabel.textColor = UIColorFromRGB(0x333333);
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:titleLabel];
        
        UIButton *closeButton = [[UIButton alloc] init];
        [closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [self addSubview:closeButton];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xE8E8E8);
        [self addSubview:lineView];
        
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = UIColorFromRGB(0xE8E8E8);
        [self addSubview:lineView2];
        
        UIButton *addButton = [[UIButton alloc] init];
        [addButton setTitle:@"+ 新建护肤方案" forState:UIControlStateNormal];
        [addButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        addButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addButton];
        
        UIView *lineView3 = [[UIView alloc] init];
        lineView3.backgroundColor = UIColorFromRGB(0xE8E8E8);
        [self addSubview:lineView3];
        
        UIButton *determineButton = [[UIButton alloc] init];
        [determineButton setTitle:@"确定" forState:UIControlStateNormal];
        [determineButton setTitleColor:COLOR_THEME forState:UIControlStateNormal];
        determineButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [determineButton addTarget:self action:@selector(determineButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:determineButton];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerNib:[UINib nibWithNibName:@"VENCosmeticBagPopupViewTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        [self addSubview:tableView];
        
        _titleLabel = titleLabel;
        _closeButton = closeButton;
        _lineView = lineView;
        _lineView2 = lineView2;
        _addButton = addButton;
        _lineView3 = lineView3;
        _determineButton = determineButton;
        _tableView = tableView;
    }
    return self;
}

- (void)setContentMuArr:(NSMutableArray *)contentMuArr {
    _contentMuArr = contentMuArr;
    
    CGFloat tableViewHeight = 75 * (contentMuArr.count > 4 ? 4 : contentMuArr.count);
    CGFloat width = self.bounds.size.width;
    
    self.lineView2.frame = CGRectMake(0, 44 + tableViewHeight, width, 1);
    self.addButton.frame = CGRectMake(0, 44 + tableViewHeight, width / 2, 48);
    self.lineView3.frame = CGRectMake(width / 2, 44 + tableViewHeight, 1, 48);
    self.determineButton.frame = CGRectMake(width / 2, 44 + tableViewHeight, width / 2, 48);
    
    self.tableView.frame = CGRectMake(0, 44, width, tableViewHeight);
    [self.tableView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    
    self.titleLabel.frame = CGRectMake(15, 12, width - 44 - 15, 20);
    self.closeButton.frame = CGRectMake(width - 44, 0, 44, 44);
    self.lineView.frame = CGRectMake(0, 43, width, 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENCosmeticBagPopupViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENCosmeticBagModel *model = self.contentMuArr[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    cell.titleLabel.text = model.name;
    cell.descriptionLabel.text = model.descriptionn;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VENCosmeticBagModel *model = self.contentMuArr[indexPath.row];
    
    self.selectIndex = model.id;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

#pragma mark - 新建方案
- (void)addButtonClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Add_PopupView" object:nil];
}

#pragma mark - 确定
- (void)determineButtonClick {
    if (![VENEmptyClass isEmptyString:self.selectIndex]) {
        NSDictionary *parameters = @{@"gid" : self.ingredients_id,
                                     @"class_id" : self.selectIndex,
                                     @"type" : @"2"};
        
        [[VENApiManager sharedManager] myCosmeticBagCollectionParameters:parameters successBlock:^(id  _Nonnull responseObject) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Remove_PopupView" object:nil];
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
