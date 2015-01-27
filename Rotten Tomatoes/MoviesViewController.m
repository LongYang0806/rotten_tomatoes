//
//  MoviesViewController.m
//  Rotten Tomatoes
//
//  Created by Long Yang on 1/23/15.
//  Copyright (c) 2015 Grace Wu/Long Yang. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCellTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"
#import "SVProgressHUD.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UILabel *networkErrorLabel;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.networkErrorLabel.hidden = YES;
    
    // Pull down to refresh
    UIRefreshControl *refreshController = [[UIRefreshControl alloc] init];
    refreshController.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshController addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshController atIndex:0];
    
    
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=50&country=us"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError != nil) {
                NSLog(@"Error Happens: %li", connectionError.code);
                self.networkErrorLabel.hidden = NO;
            } else {
                self.networkErrorLabel.hidden = YES;
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                self.movies = responseDict[@"movies"];
                NSLog(@"movies: %@", self.movies);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                
                [self.tableView reloadData];
            }
        }];
        
    });
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 128;
    
    self.title = @"Movies";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieCellTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCellTableViewCell *movieCell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCellTableViewCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    movieCell.titleCell.text = movie[@"title"];
    movieCell.bodyCell.text = movie[@"synopsis"];
    NSString *thumbnailUrl = [movie valueForKeyPath:@"posters.thumbnail"];
    NSString *originUrl = [thumbnailUrl stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
    NSLog(@"Thumbnail Url: %@, Original Url: %@", thumbnailUrl, originUrl);
    [movieCell.imageCell setImageWithURL:[NSURL URLWithString:thumbnailUrl]];
    return movieCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MovieDetailViewController *movieDetailViewController = [[MovieDetailViewController alloc] init];
    movieDetailViewController.movies = self.movies[indexPath.row];
    
    [self.navigationController pushViewController:movieDetailViewController animated:YES];
}

- (void) refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing Data..."];
    
    [self getDataFromAPICall:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=50&country=us"];
        
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}

- (void) getDataFromAPICall:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            NSLog(@"Error Happens: %li", connectionError.code);
            self.networkErrorLabel.hidden = NO;
        } else {
            self.networkErrorLabel.hidden = YES;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            self.movies = responseDict[@"movies"];
            NSLog(@"movies: %@", self.movies);
            [self.tableView reloadData];
        }

    }];
}

@end
