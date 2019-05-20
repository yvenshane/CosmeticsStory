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

@interface VENWaterfallFlowView () <UICollectionViewDataSource, XRWaterfallLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;

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
        [collectionView registerNib:[UINib nibWithNibName:@"VENWaterfallFlowViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
        [self addSubview:collectionView];
        
        _collectionView = collectionView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 0, kMainScreenWidth, 500);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VENWaterfallFlowViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    return cell;
}

- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % 3 == 0) {
        return 200;
    } else {
        return 150;
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
