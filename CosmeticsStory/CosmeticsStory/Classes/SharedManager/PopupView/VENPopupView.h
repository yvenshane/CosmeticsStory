//
//  VENPopupView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/27.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^popupViewBlock)(NSDictionary *);
@interface VENPopupView : UIView
@property (nonatomic, copy) NSString *popupViewStyle;
@property (nonatomic, copy) NSArray *dataSourceArr;
@property (nonatomic, copy) popupViewBlock popupViewBlock;
@property (nonatomic, copy) NSDictionary *selectedItem;

@end

NS_ASSUME_NONNULL_END
