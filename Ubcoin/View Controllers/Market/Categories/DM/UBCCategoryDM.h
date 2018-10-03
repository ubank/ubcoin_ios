//
//  UBCCategoryDM.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 10.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBCCategoryDM : NSObject

@property (readonly, nonatomic) NSString *ID;
@property (readonly, nonatomic) NSString *name;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (UBTableViewRowData *)rowData;

@end
