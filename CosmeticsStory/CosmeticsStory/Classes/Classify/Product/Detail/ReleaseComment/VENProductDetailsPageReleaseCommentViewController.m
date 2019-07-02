//
//  VENProductDetailsPageReleaseCommentViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/20.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENProductDetailsPageReleaseCommentViewController.h"

@interface VENProductDetailsPageReleaseCommentViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIButton *addImageButton;
@property (nonatomic, strong) UIButton *addImageButton2;
@property (nonatomic, strong) UIButton *addImageButton3;

@property (nonatomic, strong) NSMutableArray *imagesMuArr;
@property (nonatomic, strong) NSMutableArray <UIButton *> *starButtonsMuArr;

@end

@implementation VENProductDetailsPageReleaseCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"产品评价";
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    self.isPresent = YES;
    [self setupNavigationItemLeftBarButtonItem];
    
    ViewRadius(self.sendButton, 24.0f);
    
    self.titleLabel.text = self.titleText;
    
    // 添加图片
    UIButton *addImageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [addImageButton setImage:[UIImage imageNamed:@"icon_addImage"] forState:UIControlStateNormal];
    [addImageButton addTarget:self action:@selector(addImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addView addSubview:addImageButton];
    _addImageButton = addImageButton;
    
    [self setupStarView];
}

- (void)addImageButtonClick:(UIButton *)button {
    
    [self.view endEditing:YES];
    
    UIImage *image = [UIImage imageNamed:@"icon_addImage"];
    NSData *data = UIImagePNGRepresentation(image);
    
    NSData *data2 = UIImagePNGRepresentation(button.imageView.image);
    
    if ([data isEqual:data2]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *appropriateAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }];
            UIAlertAction *undeterminedAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:appropriateAction];
            [alert addAction:undeterminedAction];
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        });
    } else {
        NSLog(@"删除");
    }
}

- (IBAction)sendButtonClick:(UIButton *)button {
    if (self.contentTextView.text.length > 0) {
        
        
        NSInteger grade = 0;
        for (UIButton *button in self.starButtonsMuArr) {
            if (button.selected == YES) {
                grade++;
            }
        }
        
        NSDictionary *parameters = @{@"goods_id" : self.goods_id,
                                     @"content" : self.contentTextView.text,
                                     @"grade" : [NSString stringWithFormat:@"%ld", grade]};
        [[VENApiManager sharedManager] releaseProductCommentWithParameters:parameters images:self.imagesMuArr keyName:@"images" successBlock:^(id  _Nonnull responseObject) {

            [self dismissViewControllerAnimated:YES completion:nil];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh_Product_Detail_Page" object:nil];
        }];
    } else {
        [MBProgressHUD showText:@"请输入文字"];
    }
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    UIImage *tempImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self.imagesMuArr addObject:tempImage];
    
    if (self.imagesMuArr.count == 1) {
        [self.addImageButton setImage:tempImage forState:UIControlStateNormal];
        
        UIImage *image = [UIImage imageNamed:@"icon_addImage"];
        NSData *data = UIImagePNGRepresentation(image);
        
        NSData *data2 = UIImagePNGRepresentation(self.addImageButton.imageView.image);
        
        if (![data isEqual:data2]) {
            UIButton *addImageButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 0, 80, 80)];
            [addImageButton setImage:[UIImage imageNamed:@"icon_addImage"] forState:UIControlStateNormal];
            [addImageButton addTarget:self action:@selector(addImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.addView addSubview:addImageButton];
            _addImageButton2 = addImageButton;
        }
    } else if (self.imagesMuArr.count == 2) {
        [self.addImageButton2 setImage:tempImage forState:UIControlStateNormal];
        
        UIImage *image = [UIImage imageNamed:@"icon_addImage"];
        NSData *data = UIImagePNGRepresentation(image);
        
        NSData *data2 = UIImagePNGRepresentation(self.addImageButton.imageView.image);
        
        if (![data isEqual:data2]) {
            UIButton *addImageButton = [[UIButton alloc] initWithFrame:CGRectMake(180, 0, 80, 80)];
            [addImageButton setImage:[UIImage imageNamed:@"icon_addImage"] forState:UIControlStateNormal];
            [addImageButton addTarget:self action:@selector(addImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.addView addSubview:addImageButton];
            _addImageButton3 = addImageButton;
        }
    } else if (self.imagesMuArr.count == 3) {
        [self.addImageButton3 setImage:tempImage forState:UIControlStateNormal];
    }
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)imagesMuArr {
    if (!_imagesMuArr) {
        _imagesMuArr = [NSMutableArray array];
    }
    return _imagesMuArr;
}

- (void)setupStarView {
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * 40, 0, 40, 40)];
        [button setImage:[UIImage imageNamed:@"icon_star7"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_star6"] forState:UIControlStateSelected];
        button.tag = i;
        button.selected = YES;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.starView addSubview:button];
        [self.starButtonsMuArr addObject:button];
        
    }
}

- (void)buttonClick:(UIButton *)button {
    for (UIButton *button2 in self.starButtonsMuArr) {
        button2.selected = NO;
    }
    
    for (NSInteger i = 0; i < button.tag; i++) {
        self.starButtonsMuArr[i].selected = YES;
    }
    
    button.selected = !button.selected;
}

- (NSMutableArray *)starButtonsMuArr {
    if (!_starButtonsMuArr) {
        _starButtonsMuArr = [NSMutableArray array];
    }
    return _starButtonsMuArr;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
