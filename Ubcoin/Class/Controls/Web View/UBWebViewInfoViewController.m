//
//  UBWebViewInfoViewController.m
//  uBank
//
//  Created by Alex Ostroushko on 05/03/14.
//  Copyright (c) 2014 uBank. All rights reserved.
//

#import "UBWebViewInfoViewController.h"

@interface UBWebViewInfoViewController () <WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) NSURL *url;

@end


@implementation UBWebViewInfoViewController

- (void)dealloc
{
    self.webView.navigationDelegate = nil;
}

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    
    if (self)
    {
        self.url = url;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView = [WKWebView.alloc initWithFrame:self.view.bounds configuration:WKWebViewConfiguration.new];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    [self.view addConstraintsToFillSubview:self.webView];
    
    [self clearURLCacheAndCookies];
    
    [self updateInfo];
}

- (void)updateInfo
{
    [self.webView loadRequest:[NSURLRequest.alloc initWithURL:self.url]];
}

- (void)clearURLCacheAndCookies
{
    NSURLCache.sharedURLCache = [NSURLCache.alloc initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    
    for (NSHTTPCookie *cookie in NSHTTPCookieStorage.sharedHTTPCookieStorage.cookies)
    {
        [NSHTTPCookieStorage.sharedHTTPCookieStorage deleteCookie:cookie];
    }
}

#pragma mark - Action Methods

- (void)navigationButtonBackClick:(id)sender
{
    if (self.webView.canGoBack)
    {
        [self.webView goBack];
    }
    else
    {
        [super navigationButtonBackClick:sender];
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

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    
    if (self.delegate && ![self.delegate needHandleURL:url])
    {
        decisionHandler(WKNavigationActionPolicyCancel);
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    if ([UBNotificationHandler isHalvaURLScheme:url])
    {
        [self.navigationController popViewControllerAnimated:NO];
        
        [UBNotificationHandler openURL:url];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame)
    {
        [self.webView loadRequest:navigationAction.request];
    }
    
    return nil;
}

@end
