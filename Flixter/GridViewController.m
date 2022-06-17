//
//  CollectionsViewController.m
//  Flixter
//
//  Created by Angelina Zhang on 6/17/22.
//

#import "GridViewController.h"
#import "MoviePosterCollectionCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface GridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *movieData;
@property (weak, nonatomic) IBOutlet UICollectionView *moviesCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.loadingIndicator startAnimating];
    self.moviesCollectionView.dataSource = self;
    self.moviesCollectionView.delegate = self;
    [self.loadingIndicator startAnimating];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.moviesCollectionView insertSubview:refreshControl atIndex:0];

    [self networkRequest];
    // Do any additional setup after loading the view.
}

- (void)networkRequest {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=290a6c40d7e173d0df08968468e7af89"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
                [self displayNetworkAlert];
            }
            else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.movieData = dataDictionary[@"results"];
               // NSLog(@"%@", self.movieData);
               [self.moviesCollectionView reloadData];
            }
            [self.loadingIndicator stopAnimating];
        }];
    [task resume];
}


- (void)displayNetworkAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"It seems you're offline. Click below to reload." preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated: YES completion: nil];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.loadingIndicator startAnimating];
        [self networkRequest];
        }];
    [alertController addAction:okAction];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
    [self networkRequest];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSDictionary *dataToPass = self.movieData[self.moviesCollectionView.indexPathsForSelectedItems[0].row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.movieDetails = dataToPass;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MoviePosterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCollectionCell" forIndexPath:indexPath];
    
    NSString *urlStart = @"https://image.tmdb.org/t/p/w500";
    NSString *urlString = [urlStart stringByAppendingString:self.movieData[indexPath.row][@"poster_path"]];
    NSURL *url = [NSURL URLWithString:urlString];
        [cell.movieCollectionPoster setImageWithURL:url];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movieData.count;
}

@end
