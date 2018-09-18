//
//  UBConnectionProvider.m
//  uBank
//
//  Created by Alex Ostroushko on 04/06/14.
//  Copyright (c) 2014 uBank. All rights reserved.
//

#import "UBConnectionProvider.h"
#import "UBCUserDM.h"
#import "UBCKeyChain.h"
#import "UBCAppDelegate.h"

#import <AFNetworking/UIKit+AFNetworking.h>

@interface UBConnectionProvider ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@property (assign, nonatomic) BOOL connectionAvailable;

@end


@implementation UBConnectionProvider

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.manager = [AFHTTPSessionManager.alloc initWithSessionConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
        self.manager.operationQueue.maxConcurrentOperationCount = 5;
        self.manager.responseSerializer = AFJSONResponseSerializer.serializer;
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"application/x-gzip", nil];
        
        self.connectionAvailable = YES;
        [self startCheckingReachability];
    }
    
    return self;
}

- (void)startCheckingReachability
{
    AFNetworkReachabilityManager.sharedManager.reachabilityStatusChangeBlock = ^(AFNetworkReachabilityStatus status)
    {
        DebugLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));

        switch (status)
        {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.connectionAvailable = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                self.connectionAvailable = NO;
                break;
        }
    };
    
    [AFNetworkReachabilityManager.sharedManager startMonitoring];
}

- (void)showNoConnectionAlert
{
    [UBAlert showAlertWithTitle:@"ui_alert_title_attention" andMessage:@"error_network_unknown"];
}

#pragma mark - Request Tasks

- (NSURLSessionDataTask *)sendRequest:(NSURLRequest *)request
                         isBackground:(BOOL)isBackground
                  withCompletionBlock:(void (^)(BOOL, id))completionBlock
{
    if (self.connectionAvailable)
    {
        NSURLSessionDataTask *task = [self prepareTaskForRequest:request
                                                      showErrors:!isBackground
                                             withCompletionBlock:completionBlock];
        
        [task resume];
        
        [AFNetworkActivityIndicatorManager.sharedManager incrementActivityCount];
        
        return task;
    }
    else
    {
        if (!isBackground)
        {
            [self showNoConnectionAlert];
        }
        
        if (completionBlock)
        {
            completionBlock(NO, nil);
        }
        
        return nil;
    }
}

- (NSURLSessionDataTask *)prepareTaskForRequest:(NSURLRequest *)request
                                     showErrors:(BOOL)showErrors
                            withCompletionBlock:(void (^)(BOOL, id))completionBlock
{
    NSURLSessionDataTask *task = [self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError *_Nullable error)
    {
        [AFNetworkActivityIndicatorManager.sharedManager decrementActivityCount];
        
        if (!error)
        {   
            if (completionBlock)
            {
                completionBlock(YES, responseObject);
            }
        }
        else if ([responseObject[@"status"] isEqual:@401])
        {
            [UBAlert showAlertWithTitle:@"ui_alert_title_attention" andMessage:@"error_unauthorized"];
            
            [UBCUserDM clearUserData];
            [UBCKeyChain removeAuthorization];
            [mainAppDelegate setupStack];
            
            if (completionBlock)
            {
                completionBlock(NO, responseObject);
            }
        }
        else if (error.code != kCFURLErrorCancelled)
        {
            if (showErrors)
            {
                [self showNoConnectionAlert];
            }
            
            if (completionBlock)
            {
                completionBlock(NO, responseObject);
            }
        }
    }];
    
    return task;
}

#pragma mark - Tasks Work

- (void)cancelAllTasks
{
    [self.manager.session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> *_Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> *_Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> *_Nonnull downloadTasks)
    {
        for (NSURLSessionDataTask *task in dataTasks)
        {
            [task cancel];
        }
    }];
}

@end
