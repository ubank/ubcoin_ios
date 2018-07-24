//
//  UBCGoodDM.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UBCSellerDM.h"
#import "UBCCategoryDM.h"

static NSString * const kNotificationFavoritesChanged = @"kNotificationFavoritesChanged";

@interface UBCGoodDM : NSObject

@property (readonly, nonatomic) NSString *ID;
@property (readonly, nonatomic) NSString *title;
@property (readonly, nonatomic) NSString *desc;
@property (readonly, nonatomic) NSString *locationText;
@property (readonly, nonatomic) NSNumber *price;
@property (readonly, nonatomic) NSDate *creationDate;
@property (readonly, nonatomic) NSArray *images;
@property (readonly, nonatomic) BOOL isFavorite;
@property (readonly, nonatomic) NSDictionary *dict;

@property (readonly, nonatomic) UBCSellerDM *seller;
@property (readonly, nonatomic) UBCCategoryDM *category;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (void)toggleFavorite;

+ (NSArray *)favorites;

+ (void)saveGoods:(NSArray *)goods;
+ (NSArray *)relatedGoods;

@end
