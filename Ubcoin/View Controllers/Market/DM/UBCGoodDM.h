//
//  UBCGoodDM.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "UBCSellerDM.h"
#import "UBCCategoryDM.h"

typedef enum
{
    UBCItemStatusActive,
    UBCItemStatusCheck,
    UBCItemStatusChecking,
    UBCItemStatusBlocked
} UBCItemStatus;

static NSString * const kNotificationFavoritesChanged = @"kNotificationFavoritesChanged";

@interface UBCGoodDM : NSObject

@property (readonly, nonatomic) NSString *ID;
@property (readonly, nonatomic) NSString *title;
@property (readonly, nonatomic) NSString *desc;
@property (readonly, nonatomic) NSString *shareURL;
@property (readonly, nonatomic) NSNumber *price;
@property (readonly, nonatomic) NSNumber *priceInCurrency;
@property (readonly, nonatomic) NSString *currency;
@property (readonly, nonatomic) NSDate *creationDate;
@property (readonly, nonatomic) NSArray *images;
@property (readonly, nonatomic) BOOL isFavorite;
@property (readonly, nonatomic) CLLocation *location;
@property (readonly, nonatomic) NSDictionary *dict;
@property (readonly, nonatomic) UBCItemStatus status;

@property (readonly, nonatomic) UBCSellerDM *seller;
@property (readonly, nonatomic) UBCCategoryDM *category;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (void)toggleFavorite;

- (UBTableViewRowData *)rowData;

@end
