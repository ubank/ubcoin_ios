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

static NSString * const DEAL_STATUS_ACTIVE = @"ACTIVE";

@interface UBCDealDM : NSObject

@property (readonly, nonatomic) NSString *ID;
@property (readonly, nonatomic) NSString *status;
@property (readonly, nonatomic) UBCGoodDM *item;
@property (readonly, nonatomic) UBCSellerDM *buyer;
@property (readonly, nonatomic) UBCSellerDM *seller;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (UBTableViewRowData *)rowData;

@end
