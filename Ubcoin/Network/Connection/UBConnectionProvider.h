//
//  UBConnectionProvider.h
//  uBank
//
//  Created by Alex Ostroushko on 04/06/14.
//  Copyright (c) 2014 uBank. All rights reserved.
//

@interface UBConnectionProvider : NSObject

- (NSURLSessionDataTask *)sendRequest:(NSURLRequest *)request
                         isBackground:(BOOL)isBackground
                  withCompletionBlock:(void (^)(BOOL, id))completionBlock;

@end
