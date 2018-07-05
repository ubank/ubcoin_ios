//
//  UBCURLProvider.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBCURLProvider : NSObject

+ (NSURL *)goodsListWithPageNumber:(NSUInteger)page;

@end
