//
//  TrailerViewController.m
//  Flixter
//
//  Created by Angelina Zhang on 6/17/22.
//

#import "TrailerViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TrailerViewController ()

@property (nonatomic, strong) NSArray *movieTrailerData;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self trailerNetworkRequest];
}

- (void)trailerNetworkRequest {
    NSString *urlStart = [@"https://api.themoviedb.org/3/movie/" stringByAppendingString:self.movieId];
    NSString* urlString = [urlStart stringByAppendingString:@"/videos?api_key=290a6c40d7e173d0df08968468e7af89&language=en-US"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                self.movieTrailerData = dataDictionary[@"results"];
                [self getVideoLink];
            }
        }];
    [task resume];
}

- (void)getVideoLink {
    // Find the trailer inside array
    int trailerIndex = -1, index = 0;
    while (index < self.movieTrailerData.count && trailerIndex == -1) {
        if ([self.movieTrailerData[index][@"type"] isEqual: @"Trailer"]) {
            trailerIndex = index;
        }
        index++;
    }
    
    if (trailerIndex == -1) {
        trailerIndex = 0;
    }
    
    NSString *urlString;
    if ([self.movieTrailerData[trailerIndex][@"site"] isEqual:@"YouTube"]) {
        urlString = [@"https://www.youtube.com/watch?v=" stringByAppendingString:self.movieTrailerData[trailerIndex][@"key"]];
    } else if ([self.movieTrailerData[trailerIndex][@"site"] isEqual:@"Vimeo"]) {
        urlString = [@"https://vimeo.com/" stringByAppendingString:self.movieTrailerData[trailerIndex][@"key"]];
    }
    [self loadVideoRequest:urlString];
}

-(void)loadVideoRequest:(NSString *)videoUrl {
    NSURL *url = [NSURL URLWithString:videoUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [self.trailerWebView loadRequest:request];
}

- (IBAction)onBackButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
