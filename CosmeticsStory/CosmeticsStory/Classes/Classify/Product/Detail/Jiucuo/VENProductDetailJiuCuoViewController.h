//
//  VENProductDetailJiuCuoViewController.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/21.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VENProductDetailJiuCuoViewController : VENBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *cnNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *enNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (nonatomic, copy) NSString *cnName;
@property (nonatomic, copy) NSString *enName;
@property (nonatomic, copy) NSString *ingredients_id;

@end

NS_ASSUME_NONNULL_END
