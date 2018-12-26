//
//  UBCCategoryDM.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 10.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const DigitalGoodsID = @"dc602e1f-80d2-af0d-9588-de6f1956f4ef";

@interface UBCCategoryDM : NSObject

@property (readonly, nonatomic) NSString *ID;
@property (readonly, nonatomic) NSString *name;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (UBTableViewRowData *)rowData;

+ (UBTableViewRowData *)allCategoriesData;

@end
