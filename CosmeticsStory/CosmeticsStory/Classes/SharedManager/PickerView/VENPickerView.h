//
//  VENPickerView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENPickerView : UIView
@property (nonatomic, strong) UIView *pickerView;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat viewHeight;

- (void)show;
- (void)hidden;

@end

NS_ASSUME_NONNULL_END
