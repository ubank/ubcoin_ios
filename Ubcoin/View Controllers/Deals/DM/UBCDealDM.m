//
//  UBCDealDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCDealDM.h"
#import "UBCDealCell.h"

@implementation UBCDealDM

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _ID = dict[@"id"];
        _item = [[UBCGoodDM alloc] initWithDictionary:dict[@"item"]];
        _buyer = [[UBCSellerDM alloc] initWithDictionary:dict[@"buyer"]];
        _seller = [[UBCSellerDM alloc] initWithDictionary:dict[@"seller"]];
    }
    return self;
}

- (UBTableViewRowData *)rowData
{
    UBTableViewRowData *data = self.item.rowData;
    data.data = self;
    data.className = NSStringFromClass(UBCDealCell.class);
    return data;
}

@end
