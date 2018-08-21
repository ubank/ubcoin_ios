//
//  UBCChatController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 13.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCChatController.h"

@interface UBCChatController () <WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UBCGoodDM *item;

@end

@implementation UBCChatController

- (void)dealloc
{
    self.webView.navigationDelegate = nil;
}

- (instancetype)initWithItem:(UBCGoodDM *)item
{
    self = [super init];
    if (self)
    {
        self.item = item;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_chat";
    
    [self setupWebView];
    [self updateInfo];
}

- (void)setupWebView
{
    self.webView = [WKWebView.alloc initWithFrame:self.view.bounds configuration:WKWebViewConfiguration.new];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    [self.view addConstraintsToFillSubview:self.webView];
}

- (void)updateInfo
{
    [self startActivityIndicatorImmediately];
    __weak typeof(self) weakSelf = self;
    [UBCDataProvider.sharedProvider chatURLForItemID:self.item.ID
                                 withCompletionBlock:^(BOOL success, NSURL *url, NSURL *appURL)
     {
         if (url)
         {
             [weakSelf openChatWithURL:url appURL:appURL];
         }
         else
         {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{             
                 [weakSelf.navigationController popViewControllerAnimated:YES];
             });
         }
     }];
}

- (void)openChatWithURL:(NSURL *)url appURL:(NSURL *)appURL
{
    if ([[UIApplication sharedApplication] canOpenURL:appURL])
    {
        __weak typeof(self) weakSelf = self;
        [[UIApplication sharedApplication] openURL:appURL
                                           options:@{}
                                 completionHandler:^(BOOL success) {
                                     [weakSelf.navigationController popViewControllerAnimated:YES];
                                 }];
    }
    else
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [self startActivityIndicatorImmediately];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [self stopActivityIndicator];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self stopActivityIndicator];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self stopActivityIndicator];
}

@end
