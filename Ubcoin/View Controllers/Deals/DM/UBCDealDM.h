//
//  UBCDealDM.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UBCGoodDM.h"

@interface UBCDealDM : NSObject

@property (readonly, nonatomic) NSString *ID;
@property (readonly, nonatomic) UBCGoodDM *item;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (UBTableViewRowData *)rowData;

@end
