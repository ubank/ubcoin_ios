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
        _title = dict[@"title"];
        _desc = dict[@"description"];
        _iconURL = dict[@"image_url"];
    }
    return self;
}

- (UBTableViewRowData *)rowData
{
    UBTableViewRowData *data = UBTableViewRowData.new;
    data.data = self;
    data.title = self.title;
    data.desc = self.desc;
    data.iconURL = self.iconURL;
    data.height = 95;
    return data;
}

@end
