//
//  UBCUserDM.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 28.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UBCSellerDM.h"

@interface UBCUserDM : UBCSellerDM

@property (readonly, nonatomic) NSString *email;
@property (readonly, nonatomic) NSNumber *walletNumber;

+ (UBCUserDM *)loadProfile;
+ (void)saveUserDict:(NSDictionary *)dict;
+ (void)clearUserData;

- (UBTableViewRowData *)rowData;

@end
