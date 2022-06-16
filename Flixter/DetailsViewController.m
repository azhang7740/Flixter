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