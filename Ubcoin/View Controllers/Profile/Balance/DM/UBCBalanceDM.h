//
//  UBCBalanceDM.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 16.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBCBalanceDM : NSObject

@property (readonly, nonatomic) NSNumber *amountUBC;
@property (readonly, nonatomic) NSNumber *amountOnHold;

+ (UBCBalanceDM *)loadBalance;
+ (void)saveBalanceDict:(NSDictionary *)dict;

@end
