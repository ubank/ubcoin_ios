//
//  UBCGoodDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCGoodDM.h"
#import "UBCAuthorDM.h"

@implementation UBCGoodDM

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _ID = dict[@"id"];
        _title = dict[@"title"];
        _desc = dict[@"description"];
        _locationText = dict[@"locationText"];
        _price = dict[@"price"];
        _isFavorite = dict[@"is_favorite"];
        _creationDate = [NSDate dateFromISO8601String:dict[@"createdDate"]];
        _images = dict[@"images"];
        _seller = [[UBCAuthorDM alloc] initWithDictionary:dict[@"user"]];
    }
    return self;
}

- (void)toggleFavorite
{
    _isFavorite = !self.isFavorite;
}

@end
