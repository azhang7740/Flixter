//
//  DetailsViewController.m
//  Flixter
//
//  Created by Angelina Zhang on 6/16/22.
//

#import "DetailsViewController.h"

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
    NSLog(@"%@", self.movieDetails);
    self.movieTitleLabel.text = self.movieDetails[@"title"];
    self.movieSynopsisLabel.text = self.movieDetails[@"overview"];
    
    self.releaseDateLabel.text = [@"Release Date: " stringByAppendingString:self.movieDetails[@"release_date"]];
    
    NSString* rating = [NSString stringWithFormat:@"%@", self.movieDetails[@"vote_average"]];
    NSString* num_ratings = [NSString stringWithFormat:@"%@", self.movieDetails[@"vote_count"]];
    
    self.ratingLabel.text = [@"Rating: " stringByAppendingString:rating];
    self.reviewCountLabel.text = [@"Number of Reviews: " stringByAppendingString:num_ratings];
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
