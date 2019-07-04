//
//  VENProductDetailPageFooterView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/20.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENProductDetailPageFooterView.h"

@implementation VENProductDetailPageFooterView

- (void)setCommentNumber:(NSString *)commentNumber {
    _commentNumber = commentNumber;
    
    self.commentLabel.text = [NSString stringWithFormat:@"评论（%@）", commentNumber];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
