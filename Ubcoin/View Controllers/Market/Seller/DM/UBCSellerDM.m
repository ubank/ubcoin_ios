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
        _shareURL = dict[@"shareLink"];
        _avatarURL = dict[@"avatarUrl"];
        _locationText = dict[@"location"];
        _itemsCount = [dict[@"itemsCount"] unsignedLongValue];
        _reviewsCount = [dict[@"reviewsCount"] unsignedIntegerValue];
        _creationDate = [NSDate dateFromString:dict[@"createdDate"] inFormat:@"yyyyMMdd'T'HHmmssZ"];
    }
    return self;
}

- (UBTableViewRowData *)rowData
{
    UBTableViewRowData *data = UBTableViewRowData.new;
    data.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    data.data = self;
    data.title = self.name;
    data.iconURL = self.avatarURL;
    data.icon = [UIImage imageNamed:@"def_prof"];
    data.height = 80;
    return data;
}

@end
