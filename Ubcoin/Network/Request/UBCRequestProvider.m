//
//  UBCRequestProvider.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCRequestProvider.h"
#import "UBCKeyChain.h"

@implementation UBCRequestProvider

+ (NSMutableURLRequest *)baseRequestWithUrl:(NSURL *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *token = UBCKeyChain.authorization;
    if ([token isNotEmpty])
    {
        [request setValue:token forHTTPHeaderField:@"X-Authentication"];
    }
    
    [request setTimeoutInterval:10.0];
    return request;
}

+ (NSString*)userAgent
{
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (Apple; iOS %@) %@", [[NSBundle mainBundle] bundleIdentifier],
                           version, [[UIDevice currentDevice] systemVersion], UBLocal.shared.language];
    return userAgent;
}

#pragma mark -

+ (NSMutableURLRequest *)getRequestWithURL:(NSURL *)url
{
    NSMutableURLRequest *request = [self baseRequestWithUrl:url];
    [request setHTTPMethod:@"GET"];
    return request;
}

+ (NSMutableURLRequest *)postRequestWithURL:(NSURL *)url
{
    NSMutableURLRequest *request = [self baseRequestWithUrl:url];
    [request setHTTPMethod:@"POST"];
    return request;
}

+ (NSMutableURLRequest *)deleteRequestWithURL:(NSURL *)url
{
    NSMutableURLRequest *request = [self baseRequestWithUrl:url];
    [request setHTTPMethod:@"DELETE"];
    return request;
}

+ (NSMutableURLRequest *)postRequestWithURL:(NSURL *)url andParams:(NSDictionary *)params
{
    NSMutableURLRequest *request = [self baseRequestWithUrl:url];
    NSData *postData = params.jsonData;
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    return request;
}

+ (NSMutableURLRequest *)putRequestWithURL:(NSURL *)url andParams:(NSDictionary *)params
{
    NSMutableURLRequest *request = [self baseRequestWithUrl:url];
    NSData *postData = params.jsonData;
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:postData];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    return request;
}

+ (NSMutableURLRequest *)patchRequestWithURL:(NSURL *)url andParams:(NSDictionary *)params
{
    NSMutableURLRequest *request = [self baseRequestWithUrl:url];
    NSData *postData = params.jsonData;
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    [request setHTTPMethod:@"PATCH"];
    [request setHTTPBody:postData];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    return request;
}

@end
