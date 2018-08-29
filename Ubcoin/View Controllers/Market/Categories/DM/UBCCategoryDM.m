//
//  UBCCategoryDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 10.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCCategoryDM.h"

@implementation UBCCategoryDM

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _ID = dict[@"id"];
        _name = dict[@"name"];
    }
    return self;
}

@end
