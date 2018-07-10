//
//  UBCGoodDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCGoodDM.h"
#import "UBCAuthorDM.h"

#define FAVORITE_KEY @"favourite goods"

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
        
        _dict = dict;
    }
    return self;
}

- (void)toggleFavorite
{
    _isFavorite = !self.isFavorite;
    
    NSMutableDictionary *dict = [self.dict mutableCopy];
    [dict setObject:@(self.isFavorite) forKey:@"is_favorite"];

    NSMutableArray *favorites = [[[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_KEY] mutableCopy];
    if (!favorites)
    {
        favorites = [NSMutableArray array];
    }
    
    if (self.isFavorite)
    {
        [favorites addObject:dict];
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id != %@", dict[@"id"]];
        [favorites filterUsingPredicate:predicate];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:favorites forKey:FAVORITE_KEY];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFavoritesChanged object:nil];
}

+ (NSArray *)favorites
{
    NSArray *favorites = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_KEY];
    return [favorites map:^id(id item) {
        return [[UBCGoodDM alloc] initWithDictionary:item];
    }];
}

@end
