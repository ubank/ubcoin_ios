//
//  UBCAuthorDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCSellerDM.h"

@implementation UBCSellerDM

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (dict.count == 0)
    {
        return nil;
    }
    
    self = [super init];
    if (self)
    {
        _ID = dict[@"id"];
        _name = dict[@"name"];
        _rating = dict[@"rating"];
        _avatarURL = dict[@"avatarUrl"];
        _itemsCount = [dict[@"itemsCount"] unsignedLongValue];
        _reviewsCount = [dict[@"reviewsCount"] unsignedIntegerValue];
    }
    return self;
}

@end
