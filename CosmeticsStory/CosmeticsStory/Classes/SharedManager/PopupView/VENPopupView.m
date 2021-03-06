//
//  VENPopupView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/27.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENPopupView.h"
#import "VENPopupViewCollectionViewCell.h"

@interface VENPopupView () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@end

static NSString *const cellIdentifier = @"cellIdentifier";
static NSString *const cellIdentifier2 = @"cellIdentifier2";
@implementation VENPopupView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, self.bounds.size.height);
    self.backgroundView.frame = CGRectMake(0, 0, kMainScreenWidth, self.bounds.size.height);
    
    CGFloat count = [self.popupViewStyle isEqualToString:@"collectionView3"] ? 3.0 : 2.0;
    self.collectionView.frame = CGRectMake(0, 0, kMainScreenWidth, ceilf(self.dataSourceArr.count / count) * 30 + 30 + (ceilf(self.dataSourceArr.count / count) - 1) * 10);
}

- (void)setPopupViewStyle:(NSString *)popupViewStyle {
    _popupViewStyle = popupViewStyle;
    
    if ([popupViewStyle isEqualToString:@"tableView"]) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] init];
        [self addSubview:tableView];
        
        _tableView = tableView;
    } else {
        
        CGFloat count = [popupViewStyle isEqualToString:@"collectionView3"] ? 3.0 : 2.0;
        
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        [self addSubview:backgroundView];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 8;
        flowLayout.itemSize = CGSizeMake((kMainScreenWidth - 30 - 17) / count, 30);

        
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerNib:[UINib nibWithNibName:@"VENPopupViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier2];
        
        [backgroundView addSubview:collectionView];
        
        _backgroundView = backgroundView;
        _collectionView = collectionView;
    }
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VENPopupViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier2 forIndexPath:indexPath];
    cell.titileLabel.text = self.dataSourceArr[indexPath.row][@"name"];
    
    if ([self.popupViewStyle isEqualToString:@"collectionView3"]) {
        cell.titileLabel.textAlignment = NSTextAlignmentCenter;
        
        if ([self.selectedItem[@"id"] isEqualToString:self.dataSourceArr[indexPath.row][@"id"]] && [self.selectedItem[@"name"] isEqualToString:self.dataSourceArr[indexPath.row][@"name"]]) {
            cell.titileLabel.textColor = COLOR_THEME;
            ViewBorderRadius(cell.titileLabel, 15.0f, 1.0f, COLOR_THEME);
        } else {
            cell.titileLabel.textColor = UIColorFromRGB(0x333333);
            ViewBorderRadius(cell.titileLabel, 15.0f, 1.0f, UIColorFromRGB(0xCCCCCC));
        }
    } else {
        cell.titileLabel.textAlignment = NSTextAlignmentLeft;
        
        if ([self.selectedItem[@"id"] isEqualToString:self.dataSourceArr[indexPath.row][@"id"]] && [self.selectedItem[@"name"] isEqualToString:self.dataSourceArr[indexPath.row][@"name"]]) {
            cell.titileLabel.textColor = COLOR_THEME;
            cell.choiseImageView.hidden = NO;
        } else {
            cell.titileLabel.textColor = UIColorFromRGB(0x333333);
            cell.choiseImageView.hidden = YES;
        }
    }
    

    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.popupViewBlock(self.dataSourceArr[indexPath.row]);
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.textLabel.text = self.dataSourceArr[indexPath.row][@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.selectedItem[@"id"] isEqualToString:self.dataSourceArr[indexPath.row][@"id"]] && [self.selectedItem[@"name"] isEqualToString:self.dataSourceArr[indexPath.row][@"name"]]) {
        cell.textLabel.textColor = COLOR_THEME;
    } else {
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.popupViewBlock(self.dataSourceArr[indexPath.row]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
