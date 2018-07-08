//
//  UBCDiscountDM.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 09.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBCDiscountDM : NSObject

@property (readonly, nonatomic) NSString *ID;
@property (readonly, nonatomic) NSString *title;
@property (readonly, nonatomic) NSString *desc;
@property (readonly, nonatomic) NSString *imageURL;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
