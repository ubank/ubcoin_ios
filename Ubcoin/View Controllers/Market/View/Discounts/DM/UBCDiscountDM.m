//
//  UBCDiscountDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 09.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCDiscountDM.h"

@implementation UBCDiscountDM

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _ID = dict[@"id"];
        _title = dict[@"title"];
        _desc = dict[@"description"];
        _imageURL = dict[@"image_url"];
    }
    return self;
}

@end
