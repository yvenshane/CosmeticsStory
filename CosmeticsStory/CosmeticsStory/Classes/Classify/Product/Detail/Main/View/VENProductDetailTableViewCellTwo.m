//
//  VENProductDetailTableViewCellTwo.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/20.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENProductDetailTableViewCellTwo.h"

@implementation VENProductDetailTableViewCellTwo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIngredientContent:(NSArray *)ingredientContent {
    _ingredientContent = ingredientContent;
    
    for (UIView *subview in self.addLabelView.subviews) {
        [subview removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < ingredientContent.count; i++) {
        
        if (i > 3) { // 只显示4个
            return;
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%@：%@种", ingredientContent[i][@"name"], ingredientContent[i][@"number"]];
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        [self.addLabelView addSubview:label];

        CGFloat x = 0;
        CGFloat y = 0;
        
        if (i == 1) {
            x = 1;
            y = 0;
        } else if (i == 2) {
            x = 0;
            y = 1;
        } else if (i == 3) {
            x = 1;
            y = 1;
        }
        
        label.frame = CGRectMake(x * kMainScreenWidth / 2, y * 17 + y * 16, kMainScreenWidth / 2 - 30, 17);
    }
}

@end
