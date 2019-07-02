//
//  VENProductDetailsPageReleaseCommentViewController.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/20.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VENProductDetailsPageReleaseCommentViewController : VENBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *goods_id;

@end

NS_ASSUME_NONNULL_END
