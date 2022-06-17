//
//  DetailsViewController.m
//  Flixter
//
//  Created by Angelina Zhang on 6/16/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h";

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;

@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsisLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // NSLog(@"%@", self.movieDetails);
    self.movieTitleLabel.text = self.movieDetails[@"title"];
    self.movieSynopsisLabel.text = self.movieDetails[@"overview"];
    
    self.releaseDateLabel.text = [@"Release Date: " stringByAppendingString:self.movieDetails[@"release_date"]];
    
    NSString* rating = [NSString stringWithFormat:@"%@", self.movieDetails[@"vote_average"]];
    NSString* num_ratings = [NSString stringWithFormat:@"%@", self.movieDetails[@"vote_count"]];
    
    self.ratingLabel.text = [@"Rating: " stringByAppendingString:rating];
    self.reviewCountLabel.text = [@"Number of Reviews: " stringByAppendingString:num_ratings];
    
    // Adding in poster image data
    NSString *urlStartPoster = @"https://image.tmdb.org/t/p/w500";
    NSString *urlStringPoster = [urlStartPoster stringByAppendingString:self.movieDetails[@"poster_path"]];
    NSURL *urlPoster = [NSURL URLWithString:urlStringPoster];
    [self.posterImageView setImageWithURL:urlPoster];
    
    // Adding in backdrop image data
    NSString *urlStartBackdrop = @"https://image.tmdb.org/t/p/w500";
    NSString *urlStringBackdrop = [urlStartBackdrop stringByAppendingString:self.movieDetails[@"backdrop_path"]];
    NSURL *urlBackdrop = [NSURL URLWithString:urlStringBackdrop];
    [self.backdropImageView setImageWithURL:urlBackdrop];
    
    [self.movieSynopsisLabel sizeToFit];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *movieIdString = [NSString stringWithFormat:@"%@", self.movieDetails[@"id"]];
    TrailerViewController *trailerVC = [segue destinationViewController];
    trailerVC.movieId = movieIdString;
}

@end
