//
//  VENHomePageSearchProductHeaderFooterView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/22.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSearchProductHeaderFooterView.h"
#import "VENChipView.h"

@interface VENHomePageSearchProductHeaderFooterView ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) VENChipView *chipView;

@end

@implementation VENHomePageSearchProductHeaderFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xF8F8F8);
        [self addSubview:lineView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = UIColorFromRGB(0x333333);
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:titleLabel];
        
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.hidden = YES;
        [self addSubview:deleteButton];
        
        VENChipView *chipView = [[VENChipView alloc] init];
        chipView.chipViewBlock = ^(NSString *str) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *tempMuArr = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"SearchResults"]];
            if (![tempMuArr containsObject:str]) {
                [tempMuArr addObject:str];
            }
            [userDefaults setObject:tempMuArr forKey:@"SearchResults"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushSearchResultPage" object:nil userInfo:@{@"keyword" : str}];
        };
        [self addSubview:chipView];
        
        _lineView = lineView;
        _titleLabel = titleLabel;
        _deleteButton = deleteButton;
        _chipView = chipView;
    }
    return self;
}

- (void)setChipArr:(NSArray *)chipArr {
    _chipArr = chipArr;
    
    self.chipView.chipArr = chipArr;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.text = self.title;
    
    self.lineView.frame = CGRectMake(0, 0, kMainScreenWidth, 10);
    self.titleLabel.frame = CGRectMake(15, 13.5 + 10, kMainScreenWidth - 30, 17);
    self.deleteButton.frame = CGRectMake(kMainScreenWidth - 15 - 20, 10 + 12, 20, 20);
    self.chipView.frame = CGRectMake(0, 13.5 + 10 + 17 + 13.5, kMainScreenWidth, self.chipView.height);
}

- (void)deleteButtonClick {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"SearchResults"];
    self.headerFooterViewDeleteBlock(@"");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
