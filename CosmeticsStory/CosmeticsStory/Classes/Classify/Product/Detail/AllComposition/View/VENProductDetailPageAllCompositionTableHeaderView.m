//
//  VENProductDetailPageAllCompositionTableHeaderView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/26.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENProductDetailPageAllCompositionTableHeaderView.h"

@implementation VENProductDetailPageAllCompositionTableHeaderView

- (void)setCount:(NSInteger)count {
    _count = count;
    
    self.titleLabel.text = [NSString stringWithFormat:@"本产品含%ld种成分", (long)self.count];
    
    NSString *content = @"本产品成分表顺序为产品备案顺序，根据产品在药监局备案提供的成分表，原则上应该和产品标签一致，但由于厂家问题也有例外情况。";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_THEME range:NSMakeRange(9, 6)];
    
    self.contentLabel.attributedText = attributedString;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
