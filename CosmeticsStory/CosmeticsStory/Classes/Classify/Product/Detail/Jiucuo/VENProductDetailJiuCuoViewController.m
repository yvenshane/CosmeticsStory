//
//  VENProductDetailJiuCuoViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/21.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENProductDetailJiuCuoViewController.h"

@interface VENProductDetailJiuCuoViewController ()
@property (nonatomic, copy) NSArray *errorTypeArr;
@property (nonatomic, copy) NSString *error_id;

@end

@implementation VENProductDetailJiuCuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.]
    
    self.navigationItem.title = @"纠错";
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    ViewRadius(self.commitButton, 24.0f);
    
    [self loadDataSource];
    
    self.cnNameLabel.text = self.cnName;
    
    if ([VENEmptyClass isEmptyString:self.enName]) {
        self.enNameLabel.text = @"";
    } else {
        self.enNameLabel.text = self.enName;
    }
}

- (IBAction)typeButtonClick:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"纠错类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSDictionary *dict in self.errorTypeArr) {
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:dict[@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.error_id = dict[@"id"];
            self.typeLabel.text = dict[@"name"];
        }];
        [alert addAction:alertAction];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)commitButtonClick:(id)sender {
    
    if (![VENEmptyClass isEmptyString:self.contentTextView.text]) {
        NSDictionary *parameters = @{@"ingredients_id" : self.ingredients_id,
                                     @"error_id" : self.error_id,
                                     @"content" : self.contentTextView.text};
        
        [[VENApiManager sharedManager] searchPageProductDetailJiuCuoPageCommitWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)loadDataSource {
    [[VENApiManager sharedManager] searchPageProductDetailJiuCuoPageErrorTypeWithSuccessBlock:^(id  _Nonnull responseObject) {
        self.errorTypeArr = responseObject;
    }];
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
