//
//  VENCosmeticBagPopupViewTwo.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/24.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENCosmeticBagPopupViewTwo.h"

@interface VENCosmeticBagPopupViewTwo ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *titleLabel2;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *lineView2;
@property (nonatomic, strong) UILabel *titleLabel3;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UIView *lineView3;
@property (nonatomic, strong) UIButton *determineButton;

@end

@implementation VENCosmeticBagPopupViewTwo

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"新建护肤方案";
        titleLabel.textColor = UIColorFromRGB(0x333333);
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:titleLabel];
        
        UIButton *closeButton = [[UIButton alloc] init];
        [closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [self addSubview:closeButton];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xE8E8E8);
        [self addSubview:lineView];
        
        UILabel *titleLabel2 = [[UILabel alloc] init];
        titleLabel2.text = @"方案名";
        titleLabel2.textColor = UIColorFromRGB(0x666666);
        titleLabel2.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:titleLabel2];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.font = [UIFont systemFontOfSize:14.0f];
        textField.placeholder = @"为你的护肤方案取一个名字";
        [self addSubview:textField];
        
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = UIColorFromRGB(0xE8E8E8);
        [self addSubview:lineView2];
        
        UILabel *titleLabel3 = [[UILabel alloc] init];
        titleLabel3.text = @"描述（选填）";
        titleLabel3.textColor = UIColorFromRGB(0x666666);
        titleLabel3.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:titleLabel3];
        
        UITextField *textField2= [[UITextField alloc] init];
        textField2.font = [UIFont systemFontOfSize:14.0f];
        textField2.placeholder = @"自己创建的护肤方案";
        [self addSubview:textField2];
        
        UIView *lineView3 = [[UIView alloc] init];
        lineView3.backgroundColor = UIColorFromRGB(0xE8E8E8);
        [self addSubview:lineView3];
        
        UIButton *determineButton = [[UIButton alloc] init];
        [determineButton setTitle:@"确定" forState:UIControlStateNormal];
        [determineButton setTitleColor:COLOR_THEME forState:UIControlStateNormal];
        determineButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [determineButton addTarget:self action:@selector(determineButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:determineButton];

        _titleLabel = titleLabel;
        _closeButton = closeButton;
        
        _lineView = lineView;
        _titleLabel2 = titleLabel2;
        _textField = textField;
        
        _lineView2 = lineView2;
        _titleLabel3 = titleLabel3;
        _textField2 = textField2;
        
        _lineView3 = lineView3;
        _determineButton = determineButton;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    
    self.titleLabel.frame = CGRectMake(15, 12, width - 44 - 15, 20);
    self.closeButton.frame = CGRectMake(width - 44, 0, 44, 44);
    
    self.lineView.frame = CGRectMake(0, 43, width, 1);
    self.titleLabel2.frame = CGRectMake(15, 44 + 20, width - 30, 20);
    self.textField.frame = CGRectMake(15, 44 + 20 + 20, width - 30, 40);
    
    self.lineView2.frame = CGRectMake(0, 43 + 80, width, 1);
    self.titleLabel3.frame = CGRectMake(15, 44 + 80 + 20, width - 30, 20);
    self.textField2.frame = CGRectMake(15, 44 + 80 + 20 + 20, width - 30, 40);
    
    self.lineView3.frame = CGRectMake(0, 43 + 80 + 80, width, 1);
    self.determineButton.frame = CGRectMake(0, 44 + 80 + 80, width, 48);
}

#pragma mark - 确定
- (void)determineButtonClick {
    if (![VENEmptyClass isEmptyString:self.textField.text]) {
        
        NSDictionary *parameters = @{@"name" : self.textField.text,
                                     @"description" : self.textField2.text};
        
        [[VENApiManager sharedManager] myCosmeticBagAdditionParameters:parameters successBlock:^(id  _Nonnull responseObject) {
            
            self.cosmeticBagPopupViewTwoBlock(@"");
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
