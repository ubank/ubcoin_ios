//
//  UBCDataProvider.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBCDataProvider : NSObject

@property (class, nonatomic, readonly) UBCDataProvider *sharedProvider;

- (void)goodsListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL success, NSArray *goods, BOOL canLoadMore))completionBlock;

@end
