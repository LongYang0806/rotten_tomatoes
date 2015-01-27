//
//  MovieDetailViewController.m
//  Rotten Tomatoes
//
//  Created by Long Yang on 1/25/15.
//  Copyright (c) 2015 Grace Wu/Long Yang. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *movieDetailImage;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.movies[@"title"];
    
    self.titleLabel.text = self.movies[@"title"];
    self.synopsisLabel.text = self.movies[@"synopsis"];
    NSString *thumbnailUrl = [self.movies valueForKeyPath:@"posters.thumbnail"];
    NSString *originUrl = [thumbnailUrl stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
    NSLog(@"Thumbnail Url: %@, Original Url: %@", thumbnailUrl, originUrl);
    [self.movieDetailImage setImageWithURL:[NSURL URLWithString:originUrl]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
