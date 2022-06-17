//
//  MovieViewController.m
//  Flixter
//
//  Created by Angelina Zhang on 6/15/22.
//

#import "MovieViewController.h"
#import "TableViewCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (nonatomic, strong) NSArray *movieData;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 200;
    [self.loadingIndicator startAnimating];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];

    [self networkRequest];
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
               [self.tableView reloadData];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customMovieCell" forIndexPath:indexPath];
    
    // Update title and synopsis
    cell.titleLabel.text = self.movieData[indexPath.row][@"title"];
    cell.synopsisLabel.text = self.movieData[indexPath.row][@"overview"];
    
    // Update image
    NSString *urlStart = @"https://image.tmdb.org/t/p/w500";
    NSString *urlString = [urlStart stringByAppendingString:self.movieData[indexPath.row][@"poster_path"]];
    NSURL *url = [NSURL URLWithString:urlString];
        [cell.posterImage setImageWithURL:url];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movieData.count;
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
     NSDictionary *dataToPass = self.movieData[self.tableView.indexPathForSelectedRow.row];
     DetailsViewController *detailVC = [segue destinationViewController];
     detailVC.movieDetails = dataToPass;
 }

@end
