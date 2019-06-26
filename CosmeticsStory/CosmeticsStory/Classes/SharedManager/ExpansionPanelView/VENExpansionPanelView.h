//
//  VENExpansionPanelView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/24.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^expansionPanelViewBlock)(UIButton *);
@interface VENExpansionPanelView : UIView
@property (nonatomic, copy) NSString *expansionPanelViewStyle;
@property (nonatomic, strong) NSMutableArray *widgetMuArr;
@property (nonatomic, copy) expansionPanelViewBlock expansionPanelViewBlock;

@end

NS_ASSUME_NONNULL_END
