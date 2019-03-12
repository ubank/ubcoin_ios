//
//  UBCDealDM.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UBCGoodDM.h"
#import "UBCSellerDM.h"

static NSString * const ItemRow = @"item";

static NSString * const DEAL_STATUS_ACTIVE = @"ACTIVE";
static NSString * const DEAL_STATUS_DELIVERY = @"DELIVERY";
static NSString * const DEAL_STATUS_CONFIRMED = @"CONFIRMED";
static NSString * const DEAL_STATUS_CANCELLED = @"CANCELLED";
static NSString * const DEAL_PRICE_DEFINED = @"DELIVERY_PRICE_DEFINED";
static NSString * const DEAL_PRICE_CONFIRMED = @"DELIVERY_PRICE_CONFIRMED";

@class UBCDealStatusDM;
@interface UBCDealDM : NSObject

@property (readonly, nonatomic) NSString *ID;
@property (readonly, nonatomic) NSString *status;
@property (readonly, nonatomic) NSString *statusDescription;
@property (readonly, nonatomic) NSString *deliveryPrice;
@property (readonly, nonatomic) NSString *currencyType;
@property (readonly, nonatomic) NSString *comment;
@property (readonly, nonatomic) BOOL withDelivery;
@property (readonly, nonatomic) BOOL needAction;
@property (readonly, nonatomic) UBCGoodDM *item;
@property (readonly, nonatomic) UBCSellerDM *buyer;
@property (readonly, nonatomic) UBCSellerDM *seller;
@property (readonly, nonatomic) UBCDealStatusDM *currentStatus;
@property (readonly, nonatomic) NSArray <UBCDealStatusDM *> *statusDescriptions;
@property (readonly, nonatomic) NSDate *createdDate;
@property (readonly, nonatomic) NSDate *updatedDate;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSArray <UBTableViewSectionData *> *)sectionsData;
- (UBTableViewRowData *)rowData;

@end
