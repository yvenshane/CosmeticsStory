//
//  VENProductDetailBrandStoryViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/20.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENProductDetailBrandStoryViewController.h"
#import "VENHomePageSearchResultsViewController.h"

@interface VENProductDetailBrandStoryViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *cnNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *enNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *originLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation VENProductDetailBrandStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"品牌故事";
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.goods_brand[@"logo"]]];
    self.cnNameLabel.text = self.goods_brand[@"name_ch"];
    self.enNameLabel.text = self.goods_brand[@"name_en"];
    
    self.originLabel.text = self.goods_brand[@"founder"];
    self.dateLabel.text = self.goods_brand[@"found_time"];
    self.placeLabel.text = self.goods_brand[@"origin"];
    self.company.text = self.goods_brand[@"ascription"];
    self.urlLabel.text = self.goods_brand[@"website"];
    
    self.contentLabel.text = self.goods_brand[@"descriptionn"];
}

- (IBAction)searchButtonClick:(id)sender {
    VENHomePageSearchResultsViewController *vc = [[VENHomePageSearchResultsViewController alloc] init];
    vc.isPush = YES;
    vc.brand_id = self.goods_brand[@"id"];
    [self presentViewController:vc animated:YES completion:nil];
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
