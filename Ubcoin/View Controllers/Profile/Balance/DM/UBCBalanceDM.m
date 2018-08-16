//
//  UBCBalanceDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 16.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCBalanceDM.h"

#define BALANCE_KEY @"user balance"

@implementation UBCBalanceDM

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _amountUBC = dict[@"amountUBC"];
        _amountOnHold = dict[@"amountOnHold"];
    }
    return self;
}

+ (UBCBalanceDM *)loadBalance
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:BALANCE_KEY];
    return [[UBCBalanceDM alloc] initWithDictionary:dict];
}

+ (void)saveBalanceDict:(NSDictionary *)dict
{
    if (dict)
    {
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:BALANCE_KEY];
    }
}

@end
