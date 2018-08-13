//
//  UBCDealDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCDealDM.h"

@implementation UBCDealDM

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _ID = dict[@"id"];
        _item = [[UBCGoodDM alloc] initWithDictionary:dict[@"item"]];
    }
    return self;
}

- (UBTableViewRowData *)rowData
{
    return self.item.rowData;
}

@end
