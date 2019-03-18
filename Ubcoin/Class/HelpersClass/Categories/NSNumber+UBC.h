//
//  NSNumber+UBC.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 13.09.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (UBC)

@property (readonly, nonatomic) NSString *coinsPriceString;
@property (readonly, nonatomic) NSString *deliveryPriceString;

@end
