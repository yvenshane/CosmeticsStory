//
//  VENProductDetailTableViewCellTwo.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/20.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENProductDetailTableViewCellTwo : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *moreInformationButton;
@property (weak, nonatomic) IBOutlet UIView *addLabelView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (nonatomic, copy) NSArray *ingredientContent;

@end

NS_ASSUME_NONNULL_END
