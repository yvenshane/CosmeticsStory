//
//  VENWaterfallFlowView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/17.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENWaterfallFlowView.h"
#import "VENWaterfallFlowViewCollectionViewCell.h"
#import "XRWaterfallLayout.h"
#import "VENHomePageModel.h"

@interface VENWaterfallFlowView () <UICollectionViewDataSource, UICollectionViewDelegate, XRWaterfallLayoutDelegate>

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENWaterfallFlowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        XRWaterfallLayout *waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
        [waterfall setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(0, 10, 10, 10)];
        waterfall.delegate = self;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:waterfall];
        collectionView.backgroundColor = UIColorFromRGB(0xF6F6F6);
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"VENWaterfallFlowViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
        [self addSubview:collectionView];
        
        _collectionView = collectionView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 0, kMainScreenWidth, self.collectionView.contentSize.height);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HEIGHT" object:nil userInfo:@{@"height" : [NSString stringWithFormat:@"%f", self.collectionView.contentSize.height]}];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsNewsListArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VENWaterfallFlowViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    VENHomePageModel *model = self.goodsNewsListArr[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
//    cell.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.titileLabel.text = model.title;
    cell.dateLabel.text = model.addtime;
    [cell.likeButton setTitle:[NSString stringWithFormat:@"  %@", model.collectionCount] forState:UIControlStateNormal];
    
    CGFloat width = (kMainScreenWidth - 30 - 40) / 2;
    
    CGFloat imageWidth = [model.imageSize[@"0"] floatValue];
    CGFloat imageHeight = [model.imageSize[@"1"] floatValue];
    
    if (imageWidth > width) {
        imageWidth = width;
        imageHeight = imageHeight * (imageWidth / width );
    }
    
    cell.iconImageViewHeight.constant = imageHeight;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageModel *model = self.goodsNewsListArr[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Find_Detail_Page" object:nil userInfo:@{@"goods_id" : model.id}];
}

- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    
    VENHomePageModel *model = self.goodsNewsListArr[indexPath.row];
    
    CGFloat width = (kMainScreenWidth - 30 - 40) / 2;
    
    CGFloat imageWidth = [model.imageSize[@"0"] floatValue];
    CGFloat imageHeight = [model.imageSize[@"1"] floatValue];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = model.title;
    label.font = [UIFont systemFontOfSize:14.0f];
    label.numberOfLines = 0;
    CGFloat labelHeight = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height;
    
    if (imageWidth > width) {
        imageWidth = width;
        imageHeight = imageHeight * (imageWidth / width );
    }
    
    
    return imageHeight + 10 + 12 + labelHeight + 6 + 15 + 12;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
