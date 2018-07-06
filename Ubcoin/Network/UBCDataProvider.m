//
//  UBCDataProvider.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCDataProvider.h"
#import "UBConnectionProvider.h"
#import "UBCRequestProvider.h"
#import "UBCURLProvider.h"

@interface UBCDataProvider ()

@property (strong, nonatomic) UBConnectionProvider *connection;

@end


@implementation UBCDataProvider

+ (instancetype)sharedProvider
{
    static UBCDataProvider *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = self.new;
        sharedInstance.connection = UBConnectionProvider.new;
    });
    
    return sharedInstance;
}

- (void)goodsListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL, NSArray *, BOOL))completionBlock
{
    NSURL *url = [UBCURLProvider goodsListWithPageNumber:page];
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:url];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             
         }
     }];
}

@end
