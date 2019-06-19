//
//  VENHomePageSearchCompositionDetailCommentDetailPageViewController.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/17.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENHomePageSearchCompositionDetailCommentDetailPageViewController : UIViewController
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;

@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomLayoutConstraint;

@end

NS_ASSUME_NONNULL_END
