//
//  TrailerViewController.h
//  Flixter
//
//  Created by Angelina Zhang on 6/17/22.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrailerViewController : UIViewController
@property (weak, nonatomic) IBOutlet WKWebView *trailerWebView;

@end

NS_ASSUME_NONNULL_END
