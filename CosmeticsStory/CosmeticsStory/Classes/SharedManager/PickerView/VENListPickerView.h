//
//  VENListPickerView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENPickerView.h"
@class VENDataPageModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^listPickerViewBlock)(VENDataPageModel *);
@interface VENListPickerView : VENPickerView
@property (nonatomic, copy) NSArray *dataSourceArr;
@property (nonatomic, copy) listPickerViewBlock listPickerViewBlock;

@end

NS_ASSUME_NONNULL_END
