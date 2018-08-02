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
        _locationText = [dict valueForKeyPath:@"location.text"];
        _price = dict[@"price"];
        _isFavorite = dict[@"is_favorite"];
        _creationDate = [NSDate dateFromISO8601String:dict[@"createdDate"]];
        _images = dict[@"images"];
        _seller = [[UBCSellerDM alloc] initWithDictionary:dict[@"user"]];
        _category = [[UBCCategoryDM alloc] initWithDictionary:dict[@"category"]];
        
        _dict = dict;
    }
    return self;
}

- (void)toggleFavorite
{
    if (UBCKeyChain.authorization)
    {
        _isFavorite = !self.isFavorite;
        
        [UBCDataProvider.sharedProvider toggleFavoriteWithID:self.ID isFavorite:self.isFavorite];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFavoritesChanged object:nil];
    }
    else
    {
        [UBAlert showAlertWithTitle:nil andMessage:@"You need to be logged in"];
    }
}

- (UBTableViewRowData *)rowData
{
    UBTableViewRowData *data = UBTableViewRowData.new;
    data.data = self;
    data.title = self.title;
    data.desc = self.desc;
    data.iconURL = [self.images firstObject];
    data.height = 95;
    return data;
}

#pragma mark -

+ (void)saveGoods:(NSArray *)goods
{
    if (goods)
    {
        NSArray *dicts = [goods valueForKey:@"dict"];
        [[NSUserDefaults standardUserDefaults] setObject:dicts forKey:ALL_GOODS_KEY];
    }
}

+ (NSArray *)relatedGoods
{
    NSArray *goods = [[NSUserDefaults standardUserDefaults] objectForKey:ALL_GOODS_KEY];
    
    NSMutableSet *set = [NSMutableSet set];
    if (goods.count > 1)
    {
        for (int i = 0; i < 4; i++)
        {
            [set addObject:goods[arc4random() % [goods count]]];
        }
    }
    return [[set allObjects] map:^id(id item) {
        return [[UBCGoodDM alloc] initWithDictionary:item];
    }];
}

@end
