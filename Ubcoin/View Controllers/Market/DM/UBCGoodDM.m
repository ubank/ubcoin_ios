//
//  UBCGoodDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCGoodDM.h"
#import "UBCDealDM.h"
#import "UBCUserDM.h"
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
        _priceInCurrency = dict[@"priceInCurrency"];
        _currency = dict[@"currency"];
        _shareURL = dict[@"shareUrl"];
        _isFavorite = [dict[@"favorite"] boolValue];
        _creationDate = [NSDate dateFromString:dict[@"createdDate"] inFormat:@"yyyyMMdd'T'HHmmssZ"];
        _images = dict[@"images"];
        _status = [self statusFromString:dict[@"status"]];
        [self setupLocationWithDictionary:dict[@"location"]];
        
        _seller = [[UBCSellerDM alloc] initWithDictionary:dict[@"user"]];
        _category = [[UBCCategoryDM alloc] initWithDictionary:dict[@"category"]];
        _deals = [dict[@"purchases"] map:^id(id item) {
            return [[UBCDealDM alloc] initWithDictionary:item];
        }];
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
    
    _locationText = dict[@"text"];
}

#pragma mark -

- (BOOL)isMyItem
{
    UBCUserDM *user = [UBCUserDM loadProfile];
    return user.ID && [self.seller.ID isEqualToString:user.ID];
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

- (NSArray *)activeDeals
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status == %@", DEAL_STATUS_ACTIVE];
    return [self.deals filteredArrayUsingPredicate:predicate];
}

- (UBTableViewRowData *)rowData
{
    UBTableViewRowData *data = UBTableViewRowData.new;
    data.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    data.data = self;
    data.title = [NSString stringWithFormat:@"%@ UBC", self.price.priceString];
    data.desc = self.title;
    data.iconURL = [self.images firstObject];
    data.icon = [UIImage imageNamed:@"item_default_image"];
    data.height = 95;
    return data;
}

#pragma mark - Status

- (UBCItemStatus)statusFromString:(NSString *)status
{
    if ([status isEqualToString:@"CHECK"])
    {
        return UBCItemStatusCheck;
    }
    else if ([status isEqualToString:@"CHECKING"])
    {
        return UBCItemStatusChecking;
    }
    else if ([status isEqualToString:@"BLOCKED"])
    {
        return UBCItemStatusBlocked;
    }
    else if ([status isEqualToString:@"SOLD"])
    {
        return UBCItemStatusSold;
    }
    else if ([status isEqualToString:@"RESERVED"])
    {
        return UBCItemStatusReserved;
    }
    else if ([status isEqualToString:@"DEACTIVATED"])
    {
        return UBCItemStatusDeactivated;
    }
    return UBCItemStatusActive;
}

+ (NSString *)titleForStatus:(UBCItemStatus)status
{
    switch (status)
    {
        case UBCItemStatusActive:
            return UBLocalizedString(@"str_item_status_active", nil);
        case UBCItemStatusBlocked:
            return UBLocalizedString(@"str_item_status_blocked", nil);
        case UBCItemStatusCheck:
        case UBCItemStatusChecking:
            return UBLocalizedString(@"str_item_status_check", nil);
        case UBCItemStatusDeactivated:
            return UBLocalizedString(@"str_item_status_deactivated", nil);
        case UBCItemStatusReserved:
            return UBLocalizedString(@"str_item_status_reserved", nil);
        case UBCItemStatusSold:
            return UBLocalizedString(@"str_item_status_sold", nil);
    }
}

@end
