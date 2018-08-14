//
//  UBCGoodDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCGoodDM.h"
#import "UBCKeyChain.h"

#define ALL_GOODS_KEY @"all goods"

@implementation UBCGoodDM

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _ID = dict[@"id"];
        _title = dict[@"title"];
        _desc = dict[@"description"];
        _price = dict[@"price"];
        _shareURL = dict[@"shareUrl"];
        _isFavorite = [dict[@"favorite"] boolValue];
        _creationDate = [NSDate dateFromISO8601String:dict[@"createdDate"]];
        _images = dict[@"images"];
        [self setupLocationWithDictionary:dict[@"location"]];
        
        _seller = [[UBCSellerDM alloc] initWithDictionary:dict[@"user"]];
        _category = [[UBCCategoryDM alloc] initWithDictionary:dict[@"category"]];
        
        _dict = dict;
    }
    return self;
}

- (void)setupLocationWithDictionary:(NSDictionary *)dict
{
    NSNumber *lat = dict[@"latPoint"];
    NSNumber *lon = dict[@"longPoint"];
    if (lat && lon)
    {
        _location = [[CLLocation alloc] initWithLatitude:lat.doubleValue
                                               longitude:lon.doubleValue];
    }
}

- (void)toggleFavorite
{
    if (UBCKeyChain.authorization)
    {
        _isFavorite = !self.isFavorite;
            
        [UBCDataProvider.sharedProvider toggleFavoriteWithID:self.ID isFavorite:self.isFavorite];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFavoritesChanged object:self];
    }
    else
    {
        [UBAlert showAlertWithTitle:nil andMessage:@"str_you_need_to_be_logged_in"];
    }
}

- (UBTableViewRowData *)rowData
{
    UBTableViewRowData *data = UBTableViewRowData.new;
    data.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    data.data = self;
    data.title = self.title;
    data.desc = self.desc;
    data.iconURL = [self.images firstObject];
    data.icon = [UIImage imageNamed:@"item_default_image"];
    data.height = 95;
    return data;
}

@end
