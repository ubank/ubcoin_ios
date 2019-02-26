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
    UBCItemStatusBlocked,
    UBCItemStatusCheck,
    UBCItemStatusChecking,
    UBCItemStatusDeactivated,
    UBCItemStatusReserved,
    UBCItemStatusSold
} UBCItemStatus;

static NSString * const conditionValueNew = @"NEW";
static NSString * const conditionValueUsed = @"USED";

static NSString * const kNotificationFavoritesChanged = @"kNotificationFavoritesChanged";
static NSString * const kNotificationItemChanged = @"kNotificationItemChanged";

@interface UBCGoodDM : NSObject

@property (readonly, nonatomic) NSString *ID;
@property (readonly, nonatomic) NSString *title;
@property (readonly, nonatomic) NSString *desc;
@property (readonly, nonatomic) NSString *shareURL;
@property (readonly, nonatomic) NSNumber *rateUBC;
@property (readonly, nonatomic) NSNumber *rateETH;
@property (readonly, nonatomic) NSNumber *price;
@property (readonly, nonatomic) NSNumber *priceInCurrency;
@property (readonly, nonatomic) NSNumber *priceInETH;
@property (readonly, nonatomic) NSString *currency;
@property (readonly, nonatomic) NSDate *creationDate;
@property (readonly, nonatomic) NSArray *images;
@property (readonly, nonatomic) NSString *imageURL;
@property (readonly, nonatomic) CLLocation *location;
@property (readonly, nonatomic) NSString *locationText;
@property (readonly, nonatomic) NSString *condition;
@property (readonly, nonatomic) NSString *fileURL;
@property (readonly, nonatomic) NSString *statusDescription;
@property (readonly, nonatomic) UBCItemStatus status;
@property (readonly, nonatomic) BOOL isFavorite;
@property (readonly, nonatomic) BOOL isDigital;
@property (readonly, nonatomic) BOOL isMyItem;

@property (readonly, nonatomic) UBCSellerDM *seller;
@property (readonly, nonatomic) UBCCategoryDM *category;
@property (readonly, nonatomic) NSArray <UBCDealDM *> *deals;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (void)toggleFavorite;

- (NSArray *)activeDeals;
- (UBTableViewRowData *)rowData;

+ (NSString *)titleForStatus:(UBCItemStatus)status;

@end
