//
//  UBCTransactionDM.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 17.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBCTransactionDM : NSObject

@property (readonly, nonatomic) NSString *ID;
@property (readonly, nonatomic) NSString *from;
@property (readonly, nonatomic) NSString *to;
@property (readonly, nonatomic) NSString *status;
@property (readonly, nonatomic) NSNumber *amount;
@property (readonly, nonatomic) NSDate *date;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (UBTableViewRowData *)rowData;

@end
