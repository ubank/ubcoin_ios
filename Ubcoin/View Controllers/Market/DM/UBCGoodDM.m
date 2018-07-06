//
//  UBCGoodDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCGoodDM.h"

@implementation UBCGoodDM

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _itemID = dict[@"id"];
        _title = dict[@"title"];
        _desc = dict[@"description"];
        _locationText = dict[@"locationText"];
        _price = dict[@"price"];
        _creationDate = [NSDate dateFromISO8601String:dict[@"createdDate"]];
        _images = dict[@"images"];
    }
    return self;
}

@end
