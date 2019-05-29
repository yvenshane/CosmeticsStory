//
//  VENExpansionPanelView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/24.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENExpansionPanelView.h"

@interface VENExpansionPanelView ()
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) NSMutableArray <UIButton *> *buttonSelectedMuArr;

@end

@implementation VENExpansionPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *topLineView = [[UIView alloc] init];
        topLineView.backgroundColor = UIColorFromRGB(0xE8E8E8);
        [self addSubview:topLineView];
        
        UIView *bottomLineView = [[UIView alloc] init];
        bottomLineView.backgroundColor = UIColorFromRGB(0xE8E8E8);
        [self addSubview:bottomLineView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"UpdataTitle" object:nil];
        
        _topLineView = topLineView;
        _bottomLineView = bottomLineView;
    }
    return self;
}

- (void)notificationCenter:(NSNotification *)noti {
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            for (UILabel *label in button.subviews) {
                if ([label isKindOfClass:[UILabel class]]) {
                    for (NSInteger i = 0; i < self.widgetMuArr.count; i++) {
                        if (button.tag == i) {
                            label.text = self.widgetMuArr[i];
                            label.textColor = UIColorFromRGB(0x333333);
                        }
                    }
                }
            }
            for (UIImageView *imageView in button.subviews) {
                if ([imageView isKindOfClass:[UIImageView class]]) {
                    imageView.image = [UIImage imageNamed:@"icon_pop"];
                }
            }
        }
    }
    
    for (UIButton *button in self.buttonSelectedMuArr) {
        for (UIButton *button2 in self.subviews) {
            if ([button2 isKindOfClass:[UIButton class]]) {
                if (button.tag == button2.tag) {
                    for (UILabel *label in button.subviews) {
                        if ([label isKindOfClass:[UILabel class]]) {
                            if (button.tag != 0) {
                                label.text = noti.userInfo[@"name"];
                            }
                            label.textColor = COLOR_THEME;
                            [self.buttonSelectedMuArr removeAllObjects];
                        }
                    }
                    for (UIImageView *imageView in button.subviews) {
                        if ([imageView isKindOfClass:[UIImageView class]]) {
                            imageView.image = [UIImage imageNamed:@"icon_pop_sel"];
                        }
                    }
                }
            }
        }
    }
}

- (void)setWidgetMuArr:(NSMutableArray *)widgetMuArr {
    _widgetMuArr = widgetMuArr;
    
    CGFloat buttonWidth = self.bounds.size.width / widgetMuArr.count;
    
    for (NSInteger i = 0; i < widgetMuArr.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * buttonWidth, 1, buttonWidth, self.bounds.size.height - 2)];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = widgetMuArr[i];
        label.textColor = i == 0 ? COLOR_THEME : UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        CGFloat labelWidth = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, 17.0f)].width;
        [button addSubview:label];
        
        CGFloat labelX = buttonWidth / 2 - (labelWidth + 6 + 7) / 2;
        CGFloat labelY = self.bounds.size.height / 2 - 17 / 2;
        label.frame = CGRectMake(labelX, labelY, labelWidth, 17.0f);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(labelX + labelWidth + 6, self.bounds.size.height / 2 - 4 / 2, 7, 4)];
        imageView.image = [UIImage imageNamed:i == 0 ? @"icon_pop_sel" : @"icon_pop"];
        [button addSubview:imageView];
    }
    
}

- (void)layoutSubviews {
    self.topLineView.frame = CGRectMake(0, 0, kMainScreenWidth, 1);
    self.bottomLineView.frame = CGRectMake(0, self.bounds.size.height - 1, kMainScreenWidth, 1);
}

- (void)buttonClick:(UIButton *)button {
    [self.buttonSelectedMuArr removeAllObjects];
    [self.buttonSelectedMuArr addObject:button];
    
    self.expansionPanelViewBlock(button);
    NSLog(@"%@", self.buttonSelectedMuArr);
}

- (NSMutableArray *)buttonSelectedMuArr {
    if (!_buttonSelectedMuArr) {
        _buttonSelectedMuArr = [NSMutableArray array];
    }
    return _buttonSelectedMuArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end