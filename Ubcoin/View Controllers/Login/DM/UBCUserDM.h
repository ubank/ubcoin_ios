//
//  UBCUserDM.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 28.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBCUserDM : NSObject

@property (readonly, nonatomic) NSString *ID;
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *phone;
@property (readonly, nonatomic) NSNumber *walletNumber;

+ (UBCUserDM *)loadProfile;

@end
