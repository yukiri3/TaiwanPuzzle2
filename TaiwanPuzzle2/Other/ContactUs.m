//
//  ContactUs.m
//  TaiwanPuzzle2
//
//  Created by user on 2017/1/20.
//  Copyright © 2017年 LiChen. All rights reserved.
//

#import "ContactUs.h"
#import "UIModel.h"
#import "SVProgressHUD.h"
@interface ContactUs ()<UIWebViewDelegate>
{
    NSString *urlString;
}
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;

@end

@implementation ContactUs
- (void) back:(UIBarButtonItem *)sender {
    [SVProgressHUD dismiss];
    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
     self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.leftBarButtonItem = [UIModel setBackButtonUI:self.navigationItem.leftBarButtonItem];
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(back:)];
 
    self.navigationItem.title=@"關於我們";
    self.myWebView.delegate=self;
    self.myWebView.scalesPageToFit=YES;
    self.myWebView.scrollView.bounces = NO;
    NSURL *url = [NSURL URLWithString:@"http://www.apple.com/tw/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:request];
 
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    urlString = request.URL.absoluteString;
    
    
    
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"是否開啟瀏覽器"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"確定"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [[UIApplication sharedApplication] openURL:request.URL];
                                    }];
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"取消"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:nil];
        return false;
    }
    
    
    

    
    return true;
}
- (void) webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    
    
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
   
    [SVProgressHUD showWithStatus:@"網路發生錯誤"];
    NSLog(@"didFailLoadWithError: %@",error.description);
    
}


@end
