//
//  UBCRequestProvider.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBCRequestProvider : NSObject

+ (NSMutableURLRequest *)getRequestWithURL:(NSURL *)url;
+ (NSMutableURLRequest *)deleteRequestWithURL:(NSURL *)url;
+ (NSMutableURLRequest *)postRequestWithURL:(NSURL *)url;
+ (NSMutableURLRequest *)putRequestWithURL:(NSURL *)url andParams:(NSDictionary *)params;
+ (NSMutableURLRequest *)postRequestWithURL:(NSURL *)url andParams:(NSDictionary *)params;
+ (NSMutableURLRequest *)patchRequestWithURL:(NSURL *)url andParams:(NSDictionary *)params;

@end
